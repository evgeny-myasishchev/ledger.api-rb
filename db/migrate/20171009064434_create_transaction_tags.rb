# frozen_string_literal: true

class CreateTransactionTags < ActiveRecord::Migration[5.1]
  def change
    create_table :transaction_tags do |t|
      t.references :ledger, type: :string, foreign_key: true, null: false
      t.string :name, null: false
    end
  end
end
