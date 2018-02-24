import React from 'react';
import ReactSwipeableViews from 'react-swipeable-views';
import ImmutablePropTypes from 'react-immutable-proptypes';
import PropTypes from 'prop-types';
import ExtendedVideoPlayer from '../../../components/extended_video_player';
import classNames from 'classnames';
import { defineMessages, injectIntl } from 'react-intl';
import IconButton from '../../../components/icon_button';
import ImmutablePureComponent from 'react-immutable-pure-component';
import ImageLoader from './image_loader';

const messages = defineMessages({
  close: { id: 'lightbox.close', defaultMessage: 'Close' },
  previous: { id: 'lightbox.previous', defaultMessage: 'Previous' },
  next: { id: 'lightbox.next', defaultMessage: 'Next' },
});

@injectIntl
export default class MediaModal extends ImmutablePureComponent {

  static propTypes = {
    media: ImmutablePropTypes.list.isRequired,
    index: PropTypes.number.isRequired,
    onClose: PropTypes.func.isRequired,
    intl: PropTypes.object.isRequired,
  };

  state = {
    index: null,
    navigationShown: true,
  };

  handleSwipe = (index) => {
    this.setState({ index: index % this.props.media.size });
  }

  handleNextClick = () => {
    this.setState({ index: (this.getIndex() + 1) % this.props.media.size });
  }

  handlePrevClick = () => {
    this.setState({ index: (this.props.media.size + this.getIndex() - 1) % this.props.media.size });
  }

  handleChangeIndex = (e) => {
    const index = Number(e.currentTarget.getAttribute('data-index'));
    this.setState({ index: index % this.props.media.size });
  }

  handleKeyUp = (e) => {
    switch(e.key) {
    case 'ArrowLeft':
      this.handlePrevClick();
      break;
    case 'ArrowRight':
      this.handleNextClick();
      break;
    }
  }

  componentDidMount () {
    window.addEventListener('keyup', this.handleKeyUp, false);
  }

  componentWillUnmount () {
    window.removeEventListener('keyup', this.handleKeyUp);
  }

  getIndex () {
    return this.state.index !== null ? this.state.index : this.props.index;
  }

  render () {
    const { media, intl, onClose } = this.props;
    const { navigationShown } = this.state;

    const index = this.getIndex();
    let pagination = [];

    const leftNav  = media.size > 1 && <button tabIndex='0' className='media-modal__nav media-modal__nav--left' onClick={this.handlePrevClick} aria-label={intl.formatMessage(messages.previous)}><i className='fa fa-fw fa-chevron-left' /></button>;
    const rightNav = media.size > 1 && <button tabIndex='0' className='media-modal__nav  media-modal__nav--right' onClick={this.handleNextClick} aria-label={intl.formatMessage(messages.next)}><i className='fa fa-fw fa-chevron-right' /></button>;

    if (media.size > 1) {
      pagination = media.map((item, i) => {
        const classes = ['media-modal__button'];
        if (i === index) {
          classes.push('media-modal__button--active');
        }
        return (<li className='media-modal__page-dot' key={i}><button tabIndex='0' className={classes.join(' ')} onClick={this.handleChangeIndex} data-index={i}>{i + 1}</button></li>);
      });
    }

    const switchNavigation = () => {
      this.setState({
        navigationShown: !navigationShown,
      });
    };

    const content = media.map((image) => {
      const width  = image.getIn(['meta', 'original', 'width']) || null;
      const height = image.getIn(['meta', 'original', 'height']) || null;

      if (image.get('type') === 'image') {
        return <ImageLoader previewSrc={image.get('preview_url')} src={image.get('url')} width={width} height={height} alt={image.get('description')} key={image.get('url')} onClick={switchNavigation} />;
      } else if (image.get('type') === 'gifv') {
        return <ExtendedVideoPlayer src={image.get('url')} muted controls={false} width={width} height={height} key={image.get('preview_url')} alt={image.get('description')} onClick={switchNavigation}/>;
      }

      return null;
    }).toArray();

    const containerStyle = {
      alignItems: 'center', // center vertically
    };

    const navigationClassName = classNames('media-modal__navigation', {
      'media-modal__navigation--hidden': !navigationShown,
    });

    return (
      <div className='modal-root__modal media-modal'>
        <div
          className='media-modal__closer'
          role='presentation'
          onClick={onClose}
        >
          <div className='media-modal__content'>
            <ReactSwipeableViews
              style={{
                // on Android Chrome, pixel length of 100vh is mutable
                height: `${document.body.clientHeight}px`,
              }}
              containerStyle={containerStyle}
              onChangeIndex={this.handleSwipe}
              onSwitching={this.handleSwitching}
              index={index}
            >
              {content}
            </ReactSwipeableViews>
          </div>
        </div>
        <div className={navigationClassName}>
          <IconButton className='media-modal__close' title={intl.formatMessage(messages.close)} icon='times' onClick={onClose} size={40} />
          {leftNav}
          {rightNav}
          <ul className='media-modal__pagination'>
            {pagination}
          </ul>
        </div>
      </div>
    );
  }

}
