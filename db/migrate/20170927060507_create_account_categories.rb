# frozen_string_literal: true

class CreateAccountCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :account_categories do |t|
      t.string :ledger_id, null: false
      t.integer :display_order, null: false
      t.string :name, null: false
    end
    add_index(:account_categories, %i[id ledger_id], unique: true)
    add_foreign_key :account_categories, :ledgers, name: 'fk_account_categories_on_ledger_id_refs_ledgers_on_id'
  end
end
