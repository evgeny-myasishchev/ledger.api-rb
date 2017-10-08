# frozen_string_literal: true

class CreateAccountCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :account_categories do |t|
      t.references :ledger, foreign_key: true, null: false, type: :string
      t.integer :display_order, null: false
      t.string :name, null: false
    end
  end
end
