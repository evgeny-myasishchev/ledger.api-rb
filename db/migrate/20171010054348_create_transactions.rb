# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions, id: :string do |t|
      t.references :account, type: :string, foreign_key: true
      t.string :reported_user_id, type: :string, null: false
      t.string :type, null: false
      t.integer :amount, null: false
      t.text :comment
      t.datetime :date, null: false
      t.boolean :is_refund, null: false, default: false
      t.boolean :is_transfer, null: false, default: false
      t.boolean :is_pending, null: false, default: false

      t.timestamps
    end
  end
end
