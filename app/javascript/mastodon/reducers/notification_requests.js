import { Map as ImmutableMap, List as ImmutableList, fromJS } from 'immutable';

import { blockAccountSuccess, muteAccountSuccess } from 'mastodon/actions/accounts';
import { fetchNotificationRequests, expandNotificationRequests, fetchNotificationRequest, fetchNotificationsForRequest } from 'mastodon/actions/notification_requests';
import {
  NOTIFICATION_REQUEST_ACCEPT_REQUEST,
  NOTIFICATION_REQUEST_DISMISS_REQUEST,
  NOTIFICATION_REQUESTS_ACCEPT_REQUEST,
  NOTIFICATION_REQUESTS_DISMISS_REQUEST,
  NOTIFICATIONS_FOR_REQUEST_EXPAND_REQUEST,
  NOTIFICATIONS_FOR_REQUEST_EXPAND_SUCCESS,
  NOTIFICATIONS_FOR_REQUEST_EXPAND_FAIL,
} from 'mastodon/actions/notifications';

import { notificationToMap } from './notifications';

const initialState = ImmutableMap({
  items: ImmutableList(),
  isLoading: false,
  next: null,
  current: ImmutableMap({
    isLoading: false,
    item: null,
    removed: false,
    notifications: ImmutableMap({
      items: ImmutableList(),
      isLoading: false,
      next: null,
    }),
  }),
});

const normalizeRequest = request => fromJS({
  ...request,
  account: request.account.id,
});

const removeRequest = (state, id) => {
  if (state.getIn(['current', 'item', 'id']) === id) {
    state = state.setIn(['current', 'removed'], true);
  }

  return state.update('items', list => list.filterNot(item => item.get('id') === id));
};

const removeRequestByAccount = (state, account_id) => {
  if (state.getIn(['current', 'item', 'account']) === account_id) {
    state = state.setIn(['current', 'removed'], true);
  }

  return state.update('items', list => list.filterNot(item => item.get('account') === account_id));
};

export const notificationRequestsReducer = (state = initialState, action) => {
  switch(action.type) {
  case fetchNotificationRequests.success.type:
    return state.withMutations(map => {
      map.update('items', list => ImmutableList(action.payload.requests.map(normalizeRequest)).concat(list));
      map.set('isLoading', false);
      map.update('next', next => next ?? action.payload.next);
    });
  case expandNotificationRequests.success.type:
    return state.withMutations(map => {
      map.update('items', list => list.concat(ImmutableList(action.payload.requests.map(normalizeRequest))));
      map.set('isLoading', false);
      map.set('next', action.payload.next);
    });
  case fetchNotificationRequests.pending.type:
  case expandNotificationRequests.pending.type:
    return state.set('isLoading', true);
  case fetchNotificationRequests.failed.type:
  case expandNotificationRequests.failed.type:
    return state.set('isLoading', false);
  case NOTIFICATION_REQUEST_ACCEPT_REQUEST:
  case NOTIFICATION_REQUEST_DISMISS_REQUEST:
    return removeRequest(state, action.id);
  case NOTIFICATION_REQUESTS_ACCEPT_REQUEST:
  case NOTIFICATION_REQUESTS_DISMISS_REQUEST:
    return action.ids.reduce((state, id) => removeRequest(state, id), state);
  case blockAccountSuccess.type:
    return removeRequestByAccount(state, action.payload.relationship.id);
  case muteAccountSuccess.type:
    return action.payload.relationship.muting_notifications ? removeRequestByAccount(state, action.payload.relationship.id) : state;
  case fetchNotificationRequest.pending.type:
    return state.set('current', initialState.get('current').set('isLoading', true));
  case fetchNotificationRequest.fulfilled.type:
    return state.update('current', map => map.set('isLoading', false).set('item', normalizeRequest(action.payload.request)));
  case fetchNotificationRequest.failed.type:
    return state.update('current', map => map.set('isLoading', false));
  case fetchNotificationsForRequest.pending.type:
  case NOTIFICATIONS_FOR_REQUEST_EXPAND_REQUEST:
    return state.setIn(['current', 'notifications', 'isLoading'], true);
  case fetchNotificationsForRequest.fulfilled.type:
    return state.updateIn(['current', 'notifications'], map => map.set('isLoading', false).update('items', list => ImmutableList(action.payload.notifications.map(notificationToMap)).concat(list)).update('next', next => next ?? action.payload.next));
  case NOTIFICATIONS_FOR_REQUEST_EXPAND_SUCCESS:
    return state.updateIn(['current', 'notifications'], map => map.set('isLoading', false).update('items', list => list.concat(ImmutableList(action.notifications.map(notificationToMap)))).set('next', action.next));
  case fetchNotificationsForRequest.failed.type:
  case NOTIFICATIONS_FOR_REQUEST_EXPAND_FAIL:
    return state.setIn(['current', 'notifications', 'isLoading'], false);
  default:
    return state;
  }
};
