import { fromJS, Map as ImmutableMap, List as ImmutableList } from 'immutable';

import { blockDomainSuccess } from 'mastodon/actions/domain_blocks';
import { timelineDelete } from 'mastodon/actions/timelines_typed';

import {
  authorizeFollowRequestSuccess,
  blockAccountSuccess,
  muteAccountSuccess,
  rejectFollowRequestSuccess,
} from '../actions/accounts';
import {
  focusApp,
  unfocusApp,
} from '../actions/app';
import {
  fetchMarkers,
} from '../actions/markers';
import { clearNotifications } from '../actions/notification_groups';
import {
  notificationsUpdate,
  NOTIFICATIONS_FILTER_SET,
  NOTIFICATIONS_SCROLL_TOP,
  NOTIFICATIONS_MARK_AS_READ,
  NOTIFICATIONS_SET_BROWSER_SUPPORT,
  NOTIFICATIONS_SET_BROWSER_PERMISSION,
} from '../actions/notifications';
import { disconnectTimeline } from '../actions/timelines';
import { compareId } from '../compare_id';

const initialState = ImmutableMap({
  pendingItems: ImmutableList(),
  items: ImmutableList(),
  hasMore: true,
  top: false,
  unread: 0,
  lastReadId: '0',
  readMarkerId: '0',
  isTabVisible: true,
  isLoading: 0,
  browserSupport: false,
  browserPermission: 'default',
});

export const notificationToMap = notification => ImmutableMap({
  id: notification.id,
  type: notification.type,
  account: notification.account.id,
  created_at: notification.created_at,
  status: notification.status ? notification.status.id : null,
  report: notification.report ? fromJS(notification.report) : null,
  event: notification.event ? fromJS(notification.event) : null,
  moderation_warning: notification.moderation_warning ? fromJS(notification.moderation_warning) : null,
});

const normalizeNotification = (state, notification, usePendingItems) => {
  const top = state.get('top');

  // Under currently unknown conditions, the client may receive duplicates from the server
  if (state.get('pendingItems').some((item) => item?.get('id') === notification.id) || state.get('items').some((item) => item?.get('id') === notification.id)) {
    return state;
  }

  if (usePendingItems || !state.get('pendingItems').isEmpty()) {
    return state.update('pendingItems', list => list.unshift(notificationToMap(notification))).update('unread', unread => unread + 1);
  }

  if (shouldCountUnreadNotifications(state)) {
    state = state.update('unread', unread => unread + 1);
  } else {
    state = state.set('lastReadId', notification.id);
  }

  return state.update('items', list => {
    if (top && list.size > 40) {
      list = list.take(20);
    }

    return list.unshift(notificationToMap(notification));
  });
};

const filterNotifications = (state, accountIds, type) => {
  const helper = list => list.filterNot(item => item !== null && accountIds.includes(item.get('account')) && (type === undefined || type === item.get('type')));
  return state.update('items', helper).update('pendingItems', helper);
};

const clearUnread = (state) => {
  state = state.set('unread', state.get('pendingItems').size);
  const lastNotification = state.get('items').find(item => item !== null);
  return state.set('lastReadId', lastNotification ? lastNotification.get('id') : '0');
};

const updateTop = (state, top) => {
  state = state.set('top', top);

  if (!shouldCountUnreadNotifications(state)) {
    state = clearUnread(state);
  }

  return state;
};

const deleteByStatus = (state, statusId) => {
  const lastReadId = state.get('lastReadId');

  if (shouldCountUnreadNotifications(state)) {
    const deletedUnread = state.get('items').filter(item => item !== null && item.get('status') === statusId && compareId(item.get('id'), lastReadId) > 0);
    state = state.update('unread', unread => unread - deletedUnread.size);
  }

  const helper = list => list.filterNot(item => item !== null && item.get('status') === statusId);
  const deletedUnread = state.get('pendingItems').filter(item => item !== null && item.get('status') === statusId && compareId(item.get('id'), lastReadId) > 0);
  state = state.update('unread', unread => unread - deletedUnread.size);
  return state.update('items', helper).update('pendingItems', helper);
};

const updateVisibility = (state, visibility) => {
  state = state.set('isTabVisible', visibility);
  if (!shouldCountUnreadNotifications(state)) {
    state = state.set('readMarkerId', state.get('lastReadId'));
    state = clearUnread(state);
  }
  return state;
};

const shouldCountUnreadNotifications = (state, ignoreScroll = false) => {
  const isTabVisible   = state.get('isTabVisible');
  const isOnTop        = state.get('top');
  const lastReadId     = state.get('lastReadId');
  const lastItem       = state.get('items').findLast(item => item !== null);
  const lastItemReached = !state.get('hasMore') || lastReadId === '0' || (lastItem && compareId(lastItem.get('id'), lastReadId) <= 0);

  return !(isTabVisible && (ignoreScroll || isOnTop) && lastItemReached);
};

const recountUnread = (state, last_read_id) => {
  return state.withMutations(mutable => {
    if (compareId(last_read_id, mutable.get('lastReadId')) > 0) {
      mutable.set('lastReadId', last_read_id);
    }

    if (compareId(last_read_id, mutable.get('readMarkerId')) > 0) {
      mutable.set('readMarkerId', last_read_id);
    }

    if (state.get('unread') > 0 || shouldCountUnreadNotifications(state)) {
      mutable.set('unread', mutable.get('pendingItems').count(item => item !== null) + mutable.get('items').count(item => item && compareId(item.get('id'), last_read_id) > 0));
    }
  });
};

export default function notifications(state = initialState, action) {
  switch(action.type) {
  case fetchMarkers.fulfilled.type:
    return action.payload.markers.notifications ? recountUnread(state, action.payload.markers.notifications.last_read_id) : state;
  case focusApp.type:
    return updateVisibility(state, true);
  case unfocusApp.type:
    return updateVisibility(state, false);
  case NOTIFICATIONS_FILTER_SET:
    return state.set('items', ImmutableList()).set('pendingItems', ImmutableList()).set('hasMore', true);
  case NOTIFICATIONS_SCROLL_TOP:
    return updateTop(state, action.top);
  case notificationsUpdate.type:
    return normalizeNotification(state, action.payload.notification, action.payload.usePendingItems);
  case blockAccountSuccess.type:
    return filterNotifications(state, [action.payload.relationship.id]);
  case muteAccountSuccess.type:
    return action.payload.relationship.muting_notifications ? filterNotifications(state, [action.payload.relationship.id]) : state;
  case blockDomainSuccess.type:
    return filterNotifications(state, action.payload.accounts);
  case authorizeFollowRequestSuccess.type:
  case rejectFollowRequestSuccess.type:
    return filterNotifications(state, [action.payload.id], 'follow_request');
  case clearNotifications.pending.type:
    return state.set('items', ImmutableList()).set('pendingItems', ImmutableList()).set('hasMore', false);
  case timelineDelete.type:
    return deleteByStatus(state, action.payload.statusId);
  case disconnectTimeline.type:
    return action.payload.timeline === 'home' ?
      state.update(action.payload.usePendingItems ? 'pendingItems' : 'items', items => items.first() ? items.unshift(null) : items) :
      state;
  case NOTIFICATIONS_MARK_AS_READ:
    const lastNotification = state.get('items').find(item => item !== null);
    return lastNotification ? recountUnread(state, lastNotification.get('id')) : state;
  case NOTIFICATIONS_SET_BROWSER_SUPPORT:
    return state.set('browserSupport', action.value);
  case NOTIFICATIONS_SET_BROWSER_PERMISSION:
    return state.set('browserPermission', action.value);
  default:
    return state;
  }
}
