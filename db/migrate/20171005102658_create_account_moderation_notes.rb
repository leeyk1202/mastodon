class CreateAccountModerationNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :account_moderation_notes do |t|
      t.text :content, null: false
      t.references :account
      t.references :target_account

      t.timestamps
    end
    add_foreign_key :account_moderation_notes, :accounts, column: :target_account_id
  end
end
