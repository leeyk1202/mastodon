import ImmutablePropTypes from 'react-immutable-proptypes';
import Avatar from './avatar';
import RelativeTimestamp from './relative_timestamp';
import PureRenderMixin from 'react-addons-pure-render-mixin';
import DisplayName from './display_name';
import MediaGallery from './media_gallery';
import VideoPlayer from './video_player';
import StatusContent from './status_content';
import StatusActionBar from './status_action_bar';
import { FormattedMessage } from 'react-intl';
import emojify from '../emoji';
import escapeTextContentForBrowser from 'react/lib/escapeTextContentForBrowser';

const outerStyle = {
  padding: '8px 10px',
  paddingLeft: '68px',
  position: 'relative',
  minHeight: '48px',
  borderBottom: '1px solid #363c4b',
  cursor: 'default'
};

const Status = React.createClass({

  contextTypes: {
    router: React.PropTypes.object
  },

  propTypes: {
    status: ImmutablePropTypes.map,
    wrapped: React.PropTypes.bool,
    onReply: React.PropTypes.func,
    onFavourite: React.PropTypes.func,
    onReblog: React.PropTypes.func,
    onDelete: React.PropTypes.func,
    onOpenMedia: React.PropTypes.func,
    onBlock: React.PropTypes.func,
    me: React.PropTypes.number,
    muted: React.PropTypes.bool
  },

  mixins: [PureRenderMixin],

  handleClick () {
    const { status } = this.props;
    this.context.router.push(`/statuses/${status.getIn(['reblog', 'id'], status.get('id'))}`);
  },

  handleAccountClick (id, e) {
    if (e.button === 0) {
      e.preventDefault();
      this.context.router.push(`/accounts/${id}`);
    }
  },

  render () {
    let media = '';
    const { status, now, ...other } = this.props;

    if (status === null) {
      return <div />;
    }

    if (status.get('reblog', null) !== null && typeof status.get('reblog') === 'object') {
      let displayName = status.getIn(['account', 'display_name']);

      if (displayName.length === 0) {
        displayName = status.getIn(['account', 'username']);
      }

      const displayNameHTML = { __html: emojify(escapeTextContentForBrowser(displayName)) };

      return (
        <div style={{ cursor: 'default' }}>
          <div style={{ marginLeft: '68px', color: '#616b86', padding: '8px 0', paddingBottom: '2px', fontSize: '14px', position: 'relative' }}>
            <div style={{ position: 'absolute', 'left': '-26px'}}><i className='fa fa-fw fa-retweet'></i></div>
            <FormattedMessage id='status.reblogged_by' defaultMessage='{name} reblogged' values={{ name: <a onClick={this.handleAccountClick.bind(this, status.getIn(['account', 'id']))} href={status.getIn(['account', 'url'])} className='status__display-name muted'><strong style={{ color: '#616b86'}} dangerouslySetInnerHTML={displayNameHTML} /></a> }} />
          </div>

          <Status {...other} wrapped={true} status={status.get('reblog')} />
        </div>
      );
    }

    if (status.get('media_attachments').size > 0) {
      if (status.getIn(['media_attachments', 0, 'type']) === 'video') {
        media = <VideoPlayer media={status.getIn(['media_attachments', 0])} sensitive={status.get('sensitive')} />;
      } else {
        media = <MediaGallery media={status.get('media_attachments')} sensitive={status.get('sensitive')} height={110} onOpenMedia={this.props.onOpenMedia} />;
      }
    }

    return (
      <div className={this.props.muted ? 'muted' : ''} style={outerStyle}>
        <div style={{ fontSize: '15px' }}>
          <div style={{ float: 'right', fontSize: '14px' }}>
            <a href={status.get('url')} className='status__relative-time' style={{ color: '#616b86' }} target='_blank' rel='noopener'><RelativeTimestamp timestamp={status.get('created_at')} now={now} /></a>
          </div>

          <a onClick={this.handleAccountClick.bind(this, status.getIn(['account', 'id']))} href={status.getIn(['account', 'url'])} className='status__display-name' style={{ display: 'block', maxWidth: '100%', paddingRight: '25px', color: '#616b86' }}>
            <div className='status__avatar' style={{ position: 'absolute', left: '10px', top: '10px', width: '48px', height: '48px' }}>
              <Avatar src={status.getIn(['account', 'avatar'])} size={48} />
            </div>

            <DisplayName account={status.get('account')} />
          </a>
        </div>

        <StatusContent status={status} onClick={this.handleClick} />

        {media}

        <StatusActionBar {...this.props} />
      </div>
    );
  }

});

export default Status;
