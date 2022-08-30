import { normalizeAccount, normalizeStatus, normalizePoll, normalizeGroup } from './normalizer';

export const ACCOUNT_IMPORT  = 'ACCOUNT_IMPORT';
export const ACCOUNTS_IMPORT = 'ACCOUNTS_IMPORT';
export const STATUS_IMPORT   = 'STATUS_IMPORT';
export const STATUSES_IMPORT = 'STATUSES_IMPORT';
export const POLLS_IMPORT    = 'POLLS_IMPORT';
export const FILTERS_IMPORT  = 'FILTERS_IMPORT';
export const GROUPS_IMPORT   = 'GROUPS_IMPORT';

function pushUnique(array, object) {
  if (array.every(element => element.id !== object.id)) {
    array.push(object);
  }
}

export function importAccount(account) {
  return { type: ACCOUNT_IMPORT, account };
}

export function importAccounts(accounts) {
  return { type: ACCOUNTS_IMPORT, accounts };
}

export function importStatus(status) {
  return { type: STATUS_IMPORT, status };
}

export function importStatuses(statuses) {
  return { type: STATUSES_IMPORT, statuses };
}

export function importFilters(filters) {
  return { type: FILTERS_IMPORT, filters };
}

export function importPolls(polls) {
  return { type: POLLS_IMPORT, polls };
}

export function importGroups(groups) {
  return { type: GROUPS_IMPORT, groups };
}

export function importFetchedAccount(account) {
  return importFetchedAccounts([account]);
}

export function importFetchedAccounts(accounts) {
  const normalAccounts = [];

  function processAccount(account) {
    pushUnique(normalAccounts, normalizeAccount(account));

    if (account.moved) {
      processAccount(account.moved);
    }
  }

  accounts.forEach(processAccount);

  return importAccounts(normalAccounts);
}

export function importFetchedGroups(groups) {
  const normalGroups = [];

  function processGroup(group) {
    pushUnique(normalGroups, normalizeGroup(group));
  }

  groups.forEach(processGroup);

  return importGroups(normalGroups);
}

export function importFetchedStatus(status) {
  return importFetchedStatuses([status]);
}

export function importFetchedStatuses(statuses) {
  return (dispatch, getState) => {
    const accounts = [];
    const normalStatuses = [];
    const polls = [];
    const filters = [];
    const groups = [];

    function processStatus(status) {
      pushUnique(normalStatuses, normalizeStatus(status, getState().getIn(['statuses', status.id])));
      pushUnique(accounts, status.account);

      if (status.filtered) {
        status.filtered.forEach(result => pushUnique(filters, result.filter));
      }

      if (status.reblog && status.reblog.id) {
        processStatus(status.reblog);
      }

      if (status.poll && status.poll.id) {
        pushUnique(polls, normalizePoll(status.poll));
      }

      if (status.group && status.group.id) {
        pushUnique(groups, normalizeGroup(status.group));
      }
    }

    statuses.forEach(processStatus);

    dispatch(importGroups(groups));
    dispatch(importPolls(polls));
    dispatch(importFetchedAccounts(accounts));
    dispatch(importStatuses(normalStatuses));
    dispatch(importFilters(filters));
  };
}

export function importFetchedPoll(poll) {
  return dispatch => {
    dispatch(importPolls([normalizePoll(poll)]));
  };
}
