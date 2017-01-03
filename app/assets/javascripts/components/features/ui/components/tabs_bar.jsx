import { Link } from 'react-router';
import { FormattedMessage } from 'react-intl';

const outerStyle = {
  background: '#373b4a',
  margin: '10px',
  flex: '0 0 auto',
  marginBottom: '0'
};

const tabStyle = {
  display: 'block',
  flex: '1 1 auto',
  padding: '5px',
  color: '#fff',
  textDecoration: 'none',
  textAlign: 'center',
  fontSize: '12px',
  fontWeight: '500',
  borderBottom: '2px solid #373b4a'
};

const tabActiveStyle = {
  borderBottom: '2px solid #2b90d9',
  color: '#2b90d9'
};

const TabsBar = () => {
  return (
    <div className='tabs-bar' style={outerStyle}>
      <Link style={tabStyle} activeStyle={tabActiveStyle} to='/statuses/new'><i className='fa fa-fw fa-pencil' /> <FormattedMessage id='tabs_bar.compose' defaultMessage='Compose' /></Link>
      <Link style={tabStyle} activeStyle={tabActiveStyle} to='/timelines/home'><i className='fa fa-fw fa-home' /> <FormattedMessage id='tabs_bar.home' defaultMessage='Home' /></Link>
      <Link style={tabStyle} activeStyle={tabActiveStyle} to='/notifications'><i className='fa fa-fw fa-bell' /> <FormattedMessage id='tabs_bar.notifications' defaultMessage='Notifications' /></Link>
      <Link style={tabStyle} activeStyle={tabActiveStyle} to='/timelines/public'><i className='fa fa-fw fa-globe' /> <FormattedMessage id='tabs_bar.public' defaultMessage='Public' /></Link>
    </div>
  );
};

export default TabsBar;
