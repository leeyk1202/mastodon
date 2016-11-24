import PureRenderMixin from 'react-addons-pure-render-mixin';
import ImmutablePropTypes from 'react-immutable-proptypes';
import emojify from '../../../emoji';
import escapeTextContentForBrowser from 'react/lib/escapeTextContentForBrowser';
import { defineMessages, injectIntl, FormattedMessage } from 'react-intl';
import IconButton from '../../../components/icon_button';

const messages = defineMessages({
  unfollow: { id: 'account.unfollow', defaultMessage: 'Unfollow' },
  follow: { id: 'account.follow', defaultMessage: 'Follow' },
});

const Header = React.createClass({

  propTypes: {
    account: ImmutablePropTypes.map.isRequired,
    me: React.PropTypes.number.isRequired,
    onFollow: React.PropTypes.func.isRequired
  },

  mixins: [PureRenderMixin],

  render () {
    const { account, me, intl } = this.props;

    let displayName = account.get('display_name');
    let info        = '';
    let actionBtn   = '';

    if (displayName.length === 0) {
      displayName = account.get('username');
    }

    if (me !== account.get('id') && account.getIn(['relationship', 'followed_by'])) {
      info = <span style={{ position: 'absolute', top: '10px', right: '10px', opacity: '0.7', display: 'inline-block', verticalAlign: 'top', background: 'rgba(0, 0, 0, 0.4)', color: '#fff', textTransform: 'uppercase', fontSize: '11px', fontWeight: '500', padding: '4px', borderRadius: '4px' }}><FormattedMessage id='account.follows_you' defaultMessage='Follows you' /></span>
    }

    if (me !== account.get('id')) {
      actionBtn = (
        <div style={{ position: 'absolute', top: '10px', left: '20px' }}>
          <IconButton size={26} icon={account.getIn(['relationship', 'following']) ? 'user-times' : 'user-plus'} active={account.getIn(['relationship', 'following'])} title={intl.formatMessage(account.getIn(['relationship', 'following']) ? messages.unfollow : messages.follow)} onClick={this.props.onFollow} />
        </div>
      );
    }

    const content         = { __html: emojify(account.get('note')) };
    const displayNameHTML = { __html: emojify(escapeTextContentForBrowser(displayName)) };

    return (
      <div style={{ flex: '0 0 auto', background: '#2f3441', textAlign: 'center', backgroundImage: `url(${account.get('header')})`, backgroundSize: 'cover', position: 'relative' }}>
        <div style={{ background: 'rgba(47, 52, 65, 0.9)', padding: '20px 10px' }}>
          <a href={account.get('url')} target='_blank' rel='noopener' style={{ display: 'block', color: 'inherit', textDecoration: 'none' }}>
            <div style={{ width: '90px', margin: '0 auto', marginBottom: '10px' }}>
              <img src={account.get('avatar')} alt='' style={{ display: 'block', width: '90px', height: '90px', borderRadius: '90px' }} />
            </div>

            <span style={{ display: 'inline-block', color: '#fff', fontSize: '20px', lineHeight: '27px', fontWeight: '500' }} className='account__header__display-name' dangerouslySetInnerHTML={displayNameHTML} />
          </a>

          <span style={{ fontSize: '14px', fontWeight: '400', display: 'block', color: '#2b90d9', marginBottom: '10px' }}>@{account.get('acct')}</span>
          <div style={{ color: '#616b86', fontSize: '14px' }} className='account__header__content' dangerouslySetInnerHTML={content} />

          {info}
          {actionBtn}
        </div>
      </div>
    );
  }

});

export default injectIntl(Header);
