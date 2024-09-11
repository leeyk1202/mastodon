import {
  apiFetchNotificationRequest,
  apiFetchNotificationRequests,
  apiFetchNotifications,
} from 'mastodon/api/notifications';
import type { ApiAccountJSON } from 'mastodon/api_types/accounts';
import type {
  ApiNotificationGroupJSON,
  ApiNotificationJSON,
} from 'mastodon/api_types/notifications';
import type { ApiStatusJSON } from 'mastodon/api_types/statuses';
import type { AppDispatch, RootState } from 'mastodon/store';
import {
  createDataLoadingThunk,
} from 'mastodon/store/typed_functions';

import { importFetchedAccounts, importFetchedStatuses } from './importer';

// TODO: refactor with notification_groups
function dispatchAssociatedRecords(
  dispatch: AppDispatch,
  notifications: ApiNotificationGroupJSON[] | ApiNotificationJSON[],
) {
  const fetchedAccounts: ApiAccountJSON[] = [];
  const fetchedStatuses: ApiStatusJSON[] = [];

  notifications.forEach((notification) => {
    if (notification.type === 'admin.report') {
      fetchedAccounts.push(notification.report.target_account);
    }

    if (notification.type === 'moderation_warning') {
      fetchedAccounts.push(notification.moderation_warning.target_account);
    }

    if ('status' in notification && notification.status) {
      fetchedStatuses.push(notification.status);
    }
  });

  if (fetchedAccounts.length > 0)
    dispatch(importFetchedAccounts(fetchedAccounts));

  if (fetchedStatuses.length > 0)
    dispatch(importFetchedStatuses(fetchedStatuses));
}

export const fetchNotificationRequests = createDataLoadingThunk(
  'notificationRequests/fetch',
  async (_params, { getState }) => {
    let sinceId = undefined;

    if (getState().notificationRequests.getIn(['items'])?.size > 0) {
      sinceId = getState().notificationRequests.getIn(['items', 0, 'id']);
    }

    return apiFetchNotificationRequests({
      since_id: sinceId,
    });
  },
  ({ requests, links }, { dispatch }) => {
    const next = links.refs.find(link => link.rel === 'next');

    dispatch(importFetchedAccounts(requests.map((request) => request.from_account)));

    return { requests, next: next?.uri };
  },
);

export const fetchNotificationRequestsIfNeeded = () =>
  async (dispatch: AppDispatch, getState: () => RootState) => {
    if (getState().notificationRequests.get('isLoading')) {
      return;
    }

    await dispatch(fetchNotificationRequests());
  };

export const fetchNotificationRequest = createDataLoadingThunk(
  'notificationRequest/fetch',
  async ({ id }: { id: string }) => apiFetchNotificationRequest(id),
);

export const fetchNotificationIfNeeded = (id: string) =>
  async (dispatch: AppDispatch, getState: () => RootState) => {
    const current = getState().notificationRequests.getIn(['current']);

    if (current.getIn(['item', 'id']) === id || current.get('isLoading')) {
      return;
    }

    await dispatch(fetchNotificationRequest({ id }));
  }
;

export const expandNotificationRequests = createDataLoadingThunk(
  'notificationRequests/expand',
  async ({ nextUrl }: { nextUrl: string }) => {
    return apiFetchNotificationRequests({}, nextUrl);
  },
  ({ requests, links }, { dispatch }) => {
    const next = links.refs.find(link => link.rel === 'next');

    dispatch(importFetchedAccounts(requests.map((request) => request.from_account)));

    return { requests, next: next?.uri };
  },
);

export const expandNotificationRequestsIfNeeded = () =>
  async (dispatch: AppDispatch, getState: () => RootState) => {
    const url = getState().notificationRequests.get('next');

    if (!url || getState().notificationRequests.get('isLoading')) {
      return;
    }

    await dispatch(expandNotificationRequests(url));
  };

export const fetchNotificationsForRequest = createDataLoadingThunk(
    'notificationRequest/fetchNotifications',
    async ({ accountId, sinceId }: { accountId: string, sinceId?: string }) => {
      return apiFetchNotifications({
        since_id: sinceId,
        account_id: accountId,
      });
    },
    ({ notifications, links }, { dispatch }) => {
      const next = links.refs.find(link => link.rel === 'next');
  
      dispatchAssociatedRecords(dispatch, notifications);
  
      return { notifications, next: next?.uri };
    },
  );

export const fetchNotificationsForRequestIfNeeded = (accountId: string) =>
  async (dispatch: AppDispatch, getState: () => RootState) => {
    const current = getState().notificationRequests.get('current');
    let sinceId = undefined;

    if (current.getIn(['item', 'account']) === accountId) {
      if (current.getIn(['notifications', 'isLoading'])) {
        return;
      }
  
      if (current.getIn(['notifications', 'items'])?.size > 0) {
        sinceId = current.getIn(['notifications', 'items', 0, 'id']);
      }
    }

    await dispatch(fetchNotificationsForRequest({ accountId, sinceId }));
  };