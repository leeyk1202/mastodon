import { FormattedMessage } from 'react-intl';

import NotificationsActiveIcon from '@/material-icons/400-24px/notifications_active-fill.svg?react';
import type { NotificationGroupStatus } from 'mastodon/models/notification_group';

import type { LabelRenderer } from './notification_group_with_status';
import { NotificationWithStatus } from './notification_with_status';

const labelRenderer: LabelRenderer = (values) => (
  <FormattedMessage
    id='notification.status'
    defaultMessage='{name} just posted'
    values={values}
  />
);

export const NotificationStatus: React.FC<{
  notification: NotificationGroupStatus;
  unread: boolean;
}> = ({ notification, unread }) => (
  <NotificationWithStatus
    type='status'
    icon={NotificationsActiveIcon}
    iconId='notifications-active'
    accountIds={notification.sampleAccountIds}
    statusId={notification.statusId}
    labelRenderer={labelRenderer}
    unread={unread}
  />
);
