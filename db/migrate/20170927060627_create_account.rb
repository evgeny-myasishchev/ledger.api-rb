# frozen_string_literal: true

class CreateAccount < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts, id: :string do |t|
      t.string :ledger_id, null: false
      t.string :name, null: false
      t.integer 'sequential_number', null: false
      t.string 'owner_user_id', null: false
      t.string  'currency_code', null: false
      t.string  'name', null: false
      t.string  'unit'
      t.integer 'balance', default: 0, null: false
      t.integer 'pending_balance', default: 0, null: false
      t.boolean 'is_closed', null: false
    end
    add_foreign_key :accounts, :ledgers
  end
end
