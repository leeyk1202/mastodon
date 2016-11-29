import {
  FOLLOWERS_FETCH_SUCCESS,
  FOLLOWERS_EXPAND_SUCCESS,
  FOLLOWING_FETCH_SUCCESS,
  FOLLOWING_EXPAND_SUCCESS
} from '../actions/accounts';
import {
  REBLOGS_FETCH_SUCCESS,
  FAVOURITES_FETCH_SUCCESS
} from '../actions/interactions';
import Immutable from 'immutable';

const initialState = Immutable.Map({
  followers: Immutable.Map(),
  following: Immutable.Map(),
  reblogged_by: Immutable.Map(),
  favourited_by: Immutable.Map()
});

const normalizeList = (state, type, id, accounts, next) => {
  return state.setIn([type, id], Immutable.Map({
    next,
    items: Immutable.List(accounts.map(item => item.id))
  }));
};

const appendToList = (state, type, id, accounts, next) => {
  return state.updateIn([type, id], map => {
    return map.set('next', next).update('items', list => list.push(...accounts.map(item => item.id)));
  });
};

export default function userLists(state = initialState, action) {
  switch(action.type) {
    case FOLLOWERS_FETCH_SUCCESS:
      return normalizeList(state, 'followers', action.id, action.accounts, action.next);
    case FOLLOWERS_EXPAND_SUCCESS:
      return appendToList(state, 'followers', action.id, action.accounts, action.next);
    case FOLLOWING_FETCH_SUCCESS:
      return normalizeList(state, 'following', action.id, action.accounts, action.next);
    case FOLLOWING_EXPAND_SUCCESS:
      return appendToList(state, 'following', action.id, action.accounts, action.next);
    case REBLOGS_FETCH_SUCCESS:
      return state.setIn(['reblogged_by', action.id], Immutable.List(action.accounts.map(item => item.id)));
    case FAVOURITES_FETCH_SUCCESS:
      return state.setIn(['favourited_by', action.id], Immutable.List(action.accounts.map(item => item.id)));
    default:
      return state;
  }
};
