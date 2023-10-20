import React, { memo } from 'react';

import { FormattedMessage, FormattedNumber } from 'react-intl';

import type { ShortNumber } from 'mastodon/utils/numbers';
import {
  DECIMAL_UNITS,
  pluralReady,
  toShortNumber,
} from 'mastodon/utils/numbers';

interface ShortNumberRendererProps {
  shortNumber: ShortNumber;
}
export const ShortNumberRenderer: React.FC<ShortNumberRendererProps> = ({
  shortNumber,
}) => {
  const [rawNumber, unit, maxFractionDigits = 0] = shortNumber;

  const count = (
    <FormattedNumber
      value={rawNumber}
      maximumFractionDigits={maxFractionDigits}
    />
  );

  const values = { count, rawNumber };

  switch (unit) {
    case DECIMAL_UNITS.THOUSAND: {
      return (
        <FormattedMessage
          id='units.short.thousand'
          defaultMessage='{count}K'
          values={values}
        />
      );
    }
    case DECIMAL_UNITS.MILLION: {
      return (
        <FormattedMessage
          id='units.short.million'
          defaultMessage='{count}M'
          values={values}
        />
      );
    }
    case DECIMAL_UNITS.BILLION: {
      return (
        <FormattedMessage
          id='units.short.billion'
          defaultMessage='{count}B'
          values={values}
        />
      );
    }
    // Not sure if we should go farther - @Sasha-Sorokin
    default:
      return count;
  }
};

interface CounterProps {
  value: number;
  children?: never;
}

const _GenericCounter: React.FC<CounterProps> = ({ value }) => (
  <ShortNumberRenderer shortNumber={toShortNumber(value)} />
);
_GenericCounter.displayName = 'GenericCounter';
export const GenericCounter = memo(_GenericCounter);

const _StatusesCounter: React.FC<CounterProps> = ({ value }) => {
  const shortNumber = toShortNumber(value);
  const [, division] = shortNumber;

  return (
    <FormattedMessage
      id='account.statuses_counter'
      defaultMessage='{count, plural, one {{counter} Post} other {{counter} Posts}}'
      values={{
        count: pluralReady(value, division),
        counter: (
          <strong>
            <ShortNumberRenderer shortNumber={shortNumber} />
          </strong>
        ),
      }}
    />
  );
};
_StatusesCounter.displayName = 'StatusesCounter';
export const StatusesCounter = memo(_StatusesCounter);

const _FollowingCounter: React.FC<CounterProps> = ({ value }) => {
  const shortNumber = toShortNumber(value);
  const [, division] = shortNumber;

  return (
    <FormattedMessage
      id='account.following_counter'
      defaultMessage='{count, plural, one {{counter} Following} other {{counter} Following}}'
      values={{
        count: pluralReady(value, division),
        counter: (
          <strong>
            <ShortNumberRenderer shortNumber={shortNumber} />
          </strong>
        ),
      }}
    />
  );
};
_FollowingCounter.displayName = 'FollowingCounter';
export const FollowingCounter = memo(_FollowingCounter);

const _FollowersCounter: React.FC<CounterProps> = ({ value }) => {
  const shortNumber = toShortNumber(value);
  const [, division] = shortNumber;

  return (
    <FormattedMessage
      id='account.followers_counter'
      defaultMessage='{count, plural, one {{counter} Follower} other {{counter} Followers}}'
      values={{
        count: pluralReady(value, division),
        counter: (
          <strong>
            <ShortNumberRenderer shortNumber={shortNumber} />
          </strong>
        ),
      }}
    />
  );
};
_FollowersCounter.displayName = 'FollowersCounter';
export const FollowersCounter = memo(_FollowersCounter);
