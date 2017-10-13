# frozen_string_literal: true

class CreateTransactionTagsJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_table :transaction_tags, id: false do |t|
      t.string :ledger_id, null: false
      t.string :transaction_id, null: false
      t.integer :tag_id, null: false
      t.index %i[transaction_id ledger_id tag_id], unique: true, name: 'index_tx_tags_on_tx_id_and_ld_id_and_tag_id'
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
              ALTER TABLE transaction_tags
                ADD CONSTRAINT fk_tx_tags_on_tx_id_lid_id_refs_tx_on_id_lid
                FOREIGN KEY (transaction_id, ledger_id) REFERENCES transactions(id, ledger_id)
            SQL
        execute <<-SQL
              ALTER TABLE transaction_tags
                ADD CONSTRAINT fk_tx_tags_on_tid_lid_refs_tags_on_id_lid
                FOREIGN KEY (tag_id, ledger_id) REFERENCES tags(id, ledger_id)
            SQL
      end
      dir.down do
        execute <<-SQL
              ALTER TABLE transaction_tags
                DROP CONSTRAINT fk_tx_tags_on_tx_id_lid_id_refs_tx_on_id_lid
            SQL
        execute <<-SQL
              ALTER TABLE transaction_tags
                DROP CONSTRAINT fk_tx_tags_on_tid_lid_refs_tags_on_id_lid
            SQL
      end
    end
  end
end
