import { connect }           from 'react-redux';
import { closeModal }        from '../../../actions/modal';
import Lightbox              from '../../../components/lightbox';

const mapStateToProps = state => ({
  url: state.getIn(['modal', 'url']),
  isVisible: state.getIn(['modal', 'open'])
});

const mapDispatchToProps = dispatch => ({
  onCloseClicked () {
    dispatch(closeModal());
  },

  onOverlayClicked () {
    dispatch(closeModal());
  }
});

const imageStyle = {
  display: 'block',
  maxWidth: '80vw',
  maxHeight: '80vh'
};

const Modal = React.createClass({

  propTypes: {
    url: React.PropTypes.string,
    isVisible: React.PropTypes.bool,
    onCloseClicked: React.PropTypes.func,
    onOverlayClicked: React.PropTypes.func,
    registerOnKeyDownHandler: React.PropTypes.func
  },

  componentDidMount() {
    this.props.registerOnKeyDownHandler(this.onKeyDown);
  },

  onKeyDown (e) {
    if (e.keyCode == 27 /* Escape key */) {
      this.props.onCloseClicked();
      e.preventDefault();
    }
  },

  render () {
    const { url, ...other } = this.props;

    return (
      <Lightbox {...other}>
        <img src={url} style={imageStyle} />
      </Lightbox>
    );
  }

});

export default connect(mapStateToProps, mapDispatchToProps)(Modal);
