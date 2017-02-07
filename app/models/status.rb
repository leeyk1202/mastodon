# frozen_string_literal: true

class Status < ApplicationRecord
  include ActiveModel::Validations
  include Paginable
  include Streamable
  include Cacheable

  enum visibility: [:public, :unlisted, :private], _suffix: :visibility

  belongs_to :application, class_name: 'Doorkeeper::Application'

  belongs_to :account, inverse_of: :statuses
  belongs_to :in_reply_to_account, foreign_key: 'in_reply_to_account_id', class_name: 'Account'

  belongs_to :thread, foreign_key: 'in_reply_to_id', class_name: 'Status', inverse_of: :replies
  belongs_to :reblog, foreign_key: 'reblog_of_id', class_name: 'Status', inverse_of: :reblogs

  has_many :favourites, inverse_of: :status, dependent: :destroy
  has_many :reblogs, foreign_key: 'reblog_of_id', class_name: 'Status', inverse_of: :reblog, dependent: :destroy
  has_many :replies, foreign_key: 'in_reply_to_id', class_name: 'Status', inverse_of: :thread
  has_many :mentions, dependent: :destroy
  has_many :media_attachments, dependent: :destroy
  has_and_belongs_to_many :tags

  has_one :notification, as: :activity, dependent: :destroy
  has_one :preview_card, dependent: :destroy

  validates :account, presence: true
  validates :uri, uniqueness: true, unless: 'local?'
  validates :text, presence: true, unless: 'reblog?'
  validates_with StatusLengthValidator
  validates :reblog, uniqueness: { scope: :account, message: 'of status already exists' }, if: 'reblog?'

  default_scope { order('id desc') }

  scope :remote, -> { where.not(uri: nil) }
  scope :local, -> { where(uri: nil) }

  cache_associated :account, :application, :media_attachments, :tags, :stream_entry, mentions: :account, reblog: [:account, :application, :stream_entry, :tags, :media_attachments, mentions: :account], thread: :account

  def local?
    uri.nil?
  end

  def reblog?
    !reblog_of_id.nil?
  end

  def reply?
    !in_reply_to_id.nil?
  end

  def verb
    reblog? ? :share : :post
  end

  def object_type
    reply? ? :comment : :note
  end

  def content
    reblog? ? reblog.text : text
  end

  def target
    reblog
  end

  def title
    content
  end

  def hidden?
    private_visibility?
  end

  def permitted?(other_account = nil)
    private_visibility? ? (account.id == other_account&.id || other_account&.following?(account)) : other_account.nil? || !account.blocking?(other_account)
  end

  def ancestors(account = nil)
    ids      = (Status.find_by_sql(['WITH RECURSIVE search_tree(id, in_reply_to_id, path) AS (SELECT id, in_reply_to_id, ARRAY[id] FROM statuses WHERE id = ? UNION ALL SELECT statuses.id, statuses.in_reply_to_id, path || statuses.id FROM search_tree JOIN statuses ON statuses.id = search_tree.in_reply_to_id WHERE NOT statuses.id = ANY(path)) SELECT id FROM search_tree ORDER BY path DESC', id]) - [self]).pluck(:id)
    statuses = Status.where(id: ids).group_by(&:id)
    results  = ids.map { |id| statuses[id].first }
    results  = results.reject { |status| filter_from_context?(status, account) }

    results
  end

  def descendants(account = nil)
    ids      = (Status.find_by_sql(['WITH RECURSIVE search_tree(id, path) AS (SELECT id, ARRAY[id] FROM statuses WHERE id = ? UNION ALL SELECT statuses.id, path || statuses.id FROM search_tree JOIN statuses ON statuses.in_reply_to_id = search_tree.id WHERE NOT statuses.id = ANY(path)) SELECT id FROM search_tree ORDER BY path', id]) - [self]).pluck(:id)
    statuses = Status.where(id: ids).group_by(&:id)
    results  = ids.map { |id| statuses[id].first }
    results  = results.reject { |status| filter_from_context?(status, account) }

    results
  end

  class << self
    def as_home_timeline(account)
      where(account: [account] + account.following)
    end

    def as_public_timeline(account = nil, local_only = false)
      query = joins('LEFT OUTER JOIN accounts ON statuses.account_id = accounts.id')
              .where(visibility: :public)
              .where('(statuses.in_reply_to_id IS NULL OR statuses.in_reply_to_account_id = statuses.account_id)')
              .where('statuses.reblog_of_id IS NULL')

      query = query.where('accounts.domain IS NULL') if local_only

      account.nil? ? filter_timeline_default(query) : filter_timeline_default(filter_timeline(query, account))
    end

    def as_tag_timeline(tag, account = nil, local_only = false)
      query = tag.statuses
                 .joins('LEFT OUTER JOIN accounts ON statuses.account_id = accounts.id')
                 .where(visibility: :public)
                 .where('statuses.reblog_of_id IS NULL')

      query = query.where('accounts.domain IS NULL') if local_only

      account.nil? ? filter_timeline_default(query) : filter_timeline_default(filter_timeline(query, account))
    end

    def favourites_map(status_ids, account_id)
      Favourite.select('status_id').where(status_id: status_ids).where(account_id: account_id).map { |f| [f.status_id, true] }.to_h
    end

    def reblogs_map(status_ids, account_id)
      select('reblog_of_id').where(reblog_of_id: status_ids).where(account_id: account_id).map { |s| [s.reblog_of_id, true] }.to_h
    end

    def reload_stale_associations!(cached_items)
      account_ids = []

      cached_items.each do |item|
        account_ids << item.account_id
        account_ids << item.reblog.account_id if item.reblog?
      end

      accounts = Account.where(id: account_ids.uniq).map { |a| [a.id, a] }.to_h

      cached_items.each do |item|
        item.account = accounts[item.account_id]
        item.reblog.account = accounts[item.reblog.account_id] if item.reblog?
      end
    end

    def permitted_for(target_account, account)
      if account&.id == target_account.id || account&.following?(target_account)
        where('1 = 1')
      elsif !account.nil? && target_account.blocking?(account)
        where('1 = 0')
      else
        where.not(visibility: :private)
      end
    end

    private

    def filter_timeline(query, account)
      blocked = Block.where(account: account).pluck(:target_account_id) + Block.where(target_account: account).pluck(:account_id)
      query   = query.where('statuses.account_id NOT IN (?)', blocked) unless blocked.empty?
      query   = query.where('accounts.silenced = TRUE') if account.silenced?
      query
    end

    def filter_timeline_default(query)
      query.where('accounts.silenced = FALSE')
    end
  end

  before_validation do
    text.strip!
    spoiler_text&.strip!

    self.reblog                 = reblog.reblog if reblog? && reblog.reblog?
    self.in_reply_to_account_id = (thread.account_id == account_id && thread.reply? ? thread.in_reply_to_account_id : thread.account_id) if reply?
    self.visibility             = (account.locked? ? :private : :public) if visibility.nil?
  end

  private

  def filter_from_context?(status, account)
    account&.blocking?(status.account_id) || !status.permitted?(account)
  end
end
