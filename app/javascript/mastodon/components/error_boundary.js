import React from 'react';
import PropTypes from 'prop-types';
import { FormattedMessage } from 'react-intl';

export default class ErrorBoundary extends React.PureComponent {

  static propTypes = {
    children: PropTypes.node,
  };

  state = {
    hasError: false,
    stackTrace: undefined,
    componentStack: undefined,
  }

  componentDidCatch(error, info) {
    this.setState({
      hasError: true,
      stackTrace: error.stack,
      componentStack: info && info.componentStack,
    });
  }

  render() {
    const { hasError, stackTrace, componentStack } = this.state;

    if (!hasError) return this.props.children;

    let debugInfo = '';
    if (stackTrace) {
      debugInfo += 'Stack trace\n-----------\n\n```\n' + stackTrace.toString() + '\n```';
    }
    if (componentStack) {
      if (debugInfo) {
        debugInfo += '\n\n\n';
      }
      debugInfo += 'React component stack\n---------------------\n\n```\n' + componentStack.toString() + '\n```';
    }

    return (
      <div tabIndex='-1'>
        <div className='error-boundary'>
          <img alt='' src='/oops.png' />
          <div>
            <h1><FormattedMessage id='web_app_crash.title' defaultMessage="We're sorry, but something went wrong with the Mastodon app." /></h1>
            <p>
              <FormattedMessage id='web_app_crash.content' defaultMessage='You could try any of the following:' />
              <ul>
                <li>
                  <FormattedMessage
                    id='web_app_crash.report_issue'
                    defaultMessage='Report a bug in the {issuetracker}'
                    values={{ issuetracker: <a href='https://github.com/tootsuite/mastodon/issues' rel='noopener' target='_blank'><FormattedMessage id='web_app_crash.issue_tracker' defaultMessage='issue tracker' /></a> }}
                  />
                  { debugInfo !== '' && (
                    <details>
                      <summary><FormattedMessage id='web_app_crash.debug_info' defaultMessage='Debug information' /></summary>
                      <textarea
                        className='web_app_crash-stacktrace'
                        value={debugInfo}
                        rows='10'
                        readOnly
                      />
                    </details>
                  )}
                </li>
                <li>
                  <FormattedMessage id='web_app_crash.reload_page' defaultMessage='Reload the current page' />
                </li>
                <li>
                  <FormattedMessage
                    id='web_app_crash.change_your_settings'
                    defaultMessage='Change your {settings}'
                    values={{ settings: <a href='/settings/preferences'><FormattedMessage id='web_app_crash.settings' defaultMessage='settings' /></a> }}
                  />
                </li>
              </ul>
            </p>
          </div>
        </div>
      </div>
    );
  }

}
