import PropTypes from 'prop-types';

import { Link } from 'react-router-dom';

import { Avatar } from 'mastodon/components/avatar';
import { useAppSelector } from 'mastodon/store';

export const AuthorLink = ({ accountId }) => {
  const account = useAppSelector(state => state.getIn(['accounts', accountId]));

  return (
    <Link to={`/@${account.get('acct')}`} className='story__details__shared__author-link' data-hover-card={accountId}>
      <Avatar account={account} size={16} />
      <bdi dangerouslySetInnerHTML={{ __html: account.get('display_name_html') }} />
    </Link>
  );
};

AuthorLink.propTypes = {
  accountId: PropTypes.string.isRequired,
};
