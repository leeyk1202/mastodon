import PureRenderMixin from 'react-addons-pure-render-mixin';
import Icon from '../../../components/icon';

const ColumnHeader = React.createClass({

  propTypes: {
    icon: React.PropTypes.string,
    type: React.PropTypes.string,
    active: React.PropTypes.bool,
    onClick: React.PropTypes.func
  },

  mixins: [PureRenderMixin],

  handleClick () {
    this.props.onClick();
  },

  render () {
    const { type, active } = this.props;

    let icon = '';

    if (this.props.icon) {
      icon = <Icon icon={this.props.icon} style={{ display: 'inline-block', marginRight: '5px' }} />;
    }

    return (
      <div className={`column-header ${active ? 'active' : ''}`} onClick={this.handleClick}>
        {icon}
        {type}
      </div>
    );
  }

});

export default ColumnHeader;
