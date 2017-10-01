# frozen_string_literal: true

class CreateLedgerUsers < ActiveRecord::Migration[5.1]
  def change
    create_join_table :ledger, :users, column_options: { type: :string } do |t|
      t.index :ledger_id
      t.index :user_id
      t.boolean :is_owner, null: false, default: false
    end
    add_foreign_key :ledger_users, :ledgers
  end
end
