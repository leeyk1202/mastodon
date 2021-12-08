import React, { useState, useEffect, useRef } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { injectIntl, FormattedMessage, defineMessages } from 'react-intl';
import IconButton from '../../../../components/icon_button';
import Icon from 'mastodon/components/icon';
import {
  changeListEditorHashtag,
  addHashtagsToListEditor,
  fetchList,
} from '../../../../actions/lists';

const messages = defineMessages({
  hashtags: { id: 'lists.extend_list.hashtags', defaultMessage: 'Hashtags' },
  placeholder: {
    id: 'lists.extend_list.hashtags_placeholder',
    defaultMessage: '#first_hashtag #second_hashtag',
  },
  title: { id: 'lists.extend_list.create', defaultMessage: 'Add hashtags' },
});

const HashtagListCreator = (props) => {
  const { intl } = props;

  const label = intl.formatMessage(messages.placeholder);
  const title = intl.formatMessage(messages.title);

  const [hashtag, setHashtag] = useState(false);
  const [count, setCount] = useState(0);
  const firstUpdate = useRef(true);

  const dispatch = useDispatch();

  useEffect(() => {
    if (firstUpdate.current) {
      firstUpdate.current = false;
      setCount(count + 1);
      return;
    } else {
      dispatch(fetchList(id));
    }
    setCount(count + 1);
    console.log(count);
  }, [hashtag]);

  const [id, hashtagValue, disabled] = useSelector((state) => [
    state.getIn(['listEditor', 'listId']),
    state.getIn(['listEditor', 'hashtags']),
    state.getIn(['listEditor', 'isSubmitting']),
  ]);

  const handleChange = ({ target }) => {
    dispatch(changeListEditorHashtag(target.value));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (hashtagValue === '') {
      setHashtag(false);
    } else {
      setHashtag(true);
    }
    dispatch(addHashtagsToListEditor(false));
  };

  const handleClick = () => {
    if (hashtagValue === '') {
      setHashtag(false);
    } else {
      setHashtag(true);
    }
    dispatch(addHashtagsToListEditor(false));
  };

  return (
    <div className="search-results__section">
      <form onSubmit={handleSubmit}>
        <h5>
          <Icon id="hashtag" fixedWidth />
          <FormattedMessage
            id="search_results.hashtags"
            defaultMessage="Hashtags"
          />
        </h5>
        <div className="column-inline-form">
          <label>
            <textarea
              className="setting-text"
              value={hashtagValue}
              disabled={disabled}
              onChange={handleChange}
              placeholder={!hashtag ? label : hashtagValue}
              rows="1"
            />
          </label>
          <IconButton
            disabled={disabled}
            icon={!hashtag ? 'plus' : 'check'}
            title={title}
            onClick={handleClick}
          />
        </div>
      </form>
    </div>
  );
};

export default injectIntl(HashtagListCreator);
