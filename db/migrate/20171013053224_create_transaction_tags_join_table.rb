# frozen_string_literal: true

class CreateTransactionTagsJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :transactions, :tags, table_name: 'transaction_tags', column_options: { type: :string } do |t|
      t.string :ledger_id, null: false
      t.index %i[transaction_id tag_id], unique: true
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
              ALTER TABLE transaction_tags
                ADD CONSTRAINT fk_tx_tags_on_tag_id_lid_refs_tags_on_id_lid
                FOREIGN KEY (tag_id, ledger_id) REFERENCES accounts(id, ledger_id)
            SQL
      end
      dir.down do
        execute <<-SQL
              ALTER TABLE transaction_tags
                DROP CONSTRAINT fk_tx_tags_on_tag_id_lid_refs_tags_on_id_lid
            SQL
      end
    end
  end
end
