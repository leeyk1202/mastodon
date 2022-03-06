class MigrateHideNetworkPreference < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  # Dummy classes, to make migration possible across version changes
  class Account < ApplicationRecord
    has_one :user, inverse_of: :account
    scope :local, -> { where(domain: nil) }
  end

  class User < ApplicationRecord
    belongs_to :account
  end

  def up
    Setting.where(thing_type: 'User', var: 'hide_network').find_each do |setting|
      account = User.find(setting.thing_id).account

      ApplicationRecord.transaction do
        account.update(hide_collections: setting.value)
        setting.delete
      end
    rescue ActiveRecord::RecordNotFound
      next
    end
  end

  def down
    Account.local.where(hide_collections: true).includes(:user).find_each do |account|
      ApplicationRecord.transaction do
        account.update(hide_collections: nil)
        Setting.create(thing: account.user, var: 'hide_network', value: account.hide_collections?)
      end
    end
  end
end
