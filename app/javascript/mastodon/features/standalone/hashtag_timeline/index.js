import React from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import StatusListContainer from '../../ui/containers/status_list_container';
import {
  refreshHashtagTimeline,
  expandHashtagTimeline,
} from '../../../actions/timelines';
import Column from '../../../components/column';
import ColumnHeader from '../../../components/column_header';
import { connectHashtagStream } from '../../../actions/streaming';

@connect()
export default class HashtagTimeline extends React.PureComponent {

  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    hashtag: PropTypes.string.isRequired,
  };

  handleHeaderClick = () => {
    this.column.scrollTop();
  }

  setRef = c => {
    this.column = c;
  }

  componentDidMount () {
    const { dispatch, hashtag } = this.props;

    dispatch(refreshHashtagTimeline(hashtag));
    this.disconnect = dispatch(connectHashtagStream(hashtag));
  }

  componentWillUnmount () {
    if (this.disconnect) {
      this.disconnect();
      this.disconnect = null;
    }
  }

  handleLoadMore = () => {
    this.props.dispatch(expandHashtagTimeline(this.props.hashtag));
  }

  render () {
    const { hashtag } = this.props;

    return (
      <Column ref={this.setRef}>
        <ColumnHeader
          icon='hashtag'
          title={hashtag}
          onClick={this.handleHeaderClick}
        />

        <StatusListContainer
          trackScroll={false}
          scrollKey='standalone_hashtag_timeline'
          timelineId={`hashtag:${hashtag}`}
          loadMore={this.handleLoadMore}
        />
      </Column>
    );
  }

}
