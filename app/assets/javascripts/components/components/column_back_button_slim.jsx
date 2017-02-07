import PureRenderMixin from 'react-addons-pure-render-mixin';
import { FormattedMessage } from 'react-intl';

const outerStyle = {
  position: 'absolute',
  right: '0',
  top: '-48px',
  padding: '15px',
  fontSize: '16px',
  background: '#2f3441',
  flex: '0 0 auto',
  cursor: 'pointer',
  color: '#2b90d9'
};

const iconStyle = {
  display: 'inline-block',
  marginRight: '5px'
};

const ColumnBackButtonSlim = React.createClass({

  contextTypes: {
    router: React.PropTypes.object
  },

  mixins: [PureRenderMixin],

  handleClick () {
    this.context.router.push('/');
  },

  render () {
    return (
      <div style={{ position: 'relative' }}>
        <div style={outerStyle} onClick={this.handleClick} className='column-back-button'>
          <i className='fa fa-fw fa-chevron-left' style={iconStyle} />
          <FormattedMessage id='column_back_button.label' defaultMessage='Back' />
        </div>
      </div>
    );
  }

});

export default ColumnBackButtonSlim;
