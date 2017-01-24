# frozen_string_literal: true

class Block < ApplicationRecord
  include Paginable
  include Streamable

  belongs_to :account
  belongs_to :target_account, class_name: 'Account'

  validates :account, :target_account, presence: true
  validates :account_id, uniqueness: { scope: :target_account_id }
  
  alias_attribute :target, :target_account

  def verb
    destroyed? ? :unblock : :block
  end

  def object_type
    :person
  end

  def hidden?
    true
  end

  def title
    destroyed? ? "#{account.acct} is no longer blocking #{target_account.acct}" : "#{account.acct} blocked #{target_account.acct}"
  end
end
