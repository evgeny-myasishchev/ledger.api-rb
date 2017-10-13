# frozen_string_literal: true

class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.references :ledger, type: :string, foreign_key: true, null: false
      t.string :name, null: false
    end

    add_index(:tags, %i[id ledger_id], unique: true)
  end
end
