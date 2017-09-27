# frozen_string_literal: true

class CreateAccount < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts, id: :string do |t|
      t.string :name
    end
  end
end
