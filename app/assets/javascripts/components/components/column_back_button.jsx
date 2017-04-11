import PureRenderMixin from 'react-addons-pure-render-mixin';
import { FormattedMessage } from 'react-intl';
import Icon from './icon';

const iconStyle = {
  display: 'inline-block',
  marginRight: '5px'
};

const ColumnBackButton = React.createClass({

  contextTypes: {
    router: React.PropTypes.object
  },

  mixins: [PureRenderMixin],

  handleClick () {
    if (window.history && window.history.length == 1) this.context.router.push("/");
    else this.context.router.goBack();
  },

  render () {
    return (
      <div onClick={this.handleClick} className='column-back-button'>
        <Icon icon='chevron-left' style={iconStyle} fixedWidth={true} />
        <FormattedMessage id='column_back_button.label' defaultMessage='Back' />
      </div>
    );
  }

});

export default ColumnBackButton;
