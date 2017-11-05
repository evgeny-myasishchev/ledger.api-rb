# frozen_string_literal: true

class CreateLedgers < ActiveRecord::Migration[5.1]
  def change
    create_table :ledgers, id: :string do |t|
      t.string :name, null: false
      t.string :created_user_id, null: false
      t.string :currency_code, null: false

      t.timestamps precision: 6
    end
  end
end
