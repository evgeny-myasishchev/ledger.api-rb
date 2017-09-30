# frozen_string_literal: true

class CreateAccount < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts, id: :string do |t|
      t.string :ledger_id, null: false
      t.string :name, null: false
      t.integer 'display_order', null: false
      t.string 'created_user_id', null: false
      t.string  'currency_code', null: false
      t.string  'name', null: false
      t.string  'unit'
      t.integer 'balance', default: 0, null: false
      t.integer 'pending_balance', default: 0, null: false
      t.boolean 'is_closed', null: false, default: false
    end
    add_foreign_key :accounts, :ledgers
  end
end
