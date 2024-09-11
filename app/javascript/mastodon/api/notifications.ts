import api, { apiRequest, getLinks, apiRequestGet } from 'mastodon/api';
import type {
  ApiNotificationGroupsResultJSON,
  ApiNotificationRequestJSON,
  ApiNotificationJSON,
} from 'mastodon/api_types/notifications';

export const apiFetchNotifications = async (params?: {
  account_id?: string;
  since_id?: string;
}, url?: string) => {
  const response = await api().request<ApiNotificationJSON[]>({
    method: 'GET',
    url: url ?? '/api/v1/notifications',
    params,
  });

  return {
    notifications: response.data,
    links: getLinks(response),
  };
};

export const apiFetchNotificationGroups = async (params?: {
  url?: string
  exclude_types?: string[];
  max_id?: string;
  since_id?: string;
}) => {
  const response = await api().request<ApiNotificationGroupsResultJSON>({
    method: 'GET',
    url: '/api/v2_alpha/notifications',
    params,
  });

  const { statuses, accounts, notification_groups } = response.data;

  return {
    statuses,
    accounts,
    notifications: notification_groups,
    links: getLinks(response),
  };
};

export const apiClearNotifications = () =>
  apiRequest<undefined>('POST', 'v1/notifications/clear');

export const apiFetchNotificationRequests = async (params?: {
  since_id?: string;
}, url?: string) => {
  const response = await api().request<ApiNotificationRequestJSON[]>({
    method: 'GET',
    url: url ?? '/api/v1/notifications/requests',
    params,
  });

  return {
    requests: response.data,
    links: getLinks(response),
  };
};

export const apiFetchNotificationRequest = async (id: string) => {
  return apiRequestGet<ApiNotificationRequestJSON>(`/api/v1/notifications/requests/${id}`);
};
