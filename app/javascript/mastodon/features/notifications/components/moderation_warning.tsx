import { defineMessages, FormattedMessage, useIntl } from 'react-intl';

import GavelIcon from '@/material-icons/400-24px/gavel.svg?react';
import { Icon } from 'mastodon/components/icon';

// This needs to be kept in sync with app/models/account_warning.rb
const messages = defineMessages({
  none: {
    id: 'notification.moderation_warning.action_none',
    defaultMessage: 'Your account has received a moderation warning.',
  },
  disable: {
    id: 'notification.moderation_warning.action_disable',
    defaultMessage: 'Your account has been disabled.',
  },
  mark_statuses_as_sensitive: {
    id: 'notification.moderation_warning.action_mark_statuses_as_sensitive',
    defaultMessage: 'Some of your posts have been marked as sensitive.',
  },
  delete_statuses: {
    id: 'notification.moderation_warning.action_delete_statuses',
    defaultMessage: 'Some of your posts have been removed.',
  },
  sensitive: {
    id: 'notification.moderation_warning.action_sensitive',
    defaultMessage: 'Your posts will be marked as sensitive from now on.',
  },
  silence: {
    id: 'notification.moderation_warning.action_silence',
    defaultMessage: 'Your account has been limited.',
  },
  suspend: {
    id: 'notification.moderation_warning.action_suspend',
    defaultMessage: 'Your account has been suspended.',
  },
});

interface Props {
  action:
    | 'none'
    | 'disable'
    | 'mark_statuses_as_sensitive'
    | 'delete_statuses'
    | 'sensitive'
    | 'silence'
    | 'suspend';
  id: string;
  hidden: boolean;
}

export const ModerationWarning: React.FC<Props> = ({ action, id, hidden }) => {
  const intl = useIntl();

  if (hidden) {
    return null;
  }

  return (
    <div className='notification-group notification-group--link notification-group--moderation-warning focusable' tabIndex='0'>
      <div className='notification-group__icon'><Icon id='warning' icon={GavelIcon} /></div>

      <div className='notification-group__main'>
        <p>{intl.formatMessage(messages[action])}</p>
        <a href={`/disputes/strikes/${id}`} target='_blank' rel='noopener noreferrer' className='link-button'>
          <FormattedMessage
            id='notification.moderation-warning.learn_more'
            defaultMessage='Learn more'
          />
        </a>
      </div>
    </div>
  );
};
