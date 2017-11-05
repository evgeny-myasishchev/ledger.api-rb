# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions, id: :string do |t|
      t.string :ledger_id, null: false
      t.string :account_id
      t.string :reported_user_id, type: :string, null: false
      t.string :type_id, null: false
      t.integer :amount, null: false
      t.text :comment
      t.datetime :date, null: false, precision: 6
      t.boolean :is_refund, null: false, default: false
      t.boolean :is_transfer, null: false, default: false
      t.boolean :is_pending, null: false, default: false
      t.index %i[id ledger_id], unique: true

      t.timestamps precision: 6
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
              ALTER TABLE transactions
                ADD CONSTRAINT fk_tx_on_acc_id_lid_refs_acc_on_acc_id_lid
                FOREIGN KEY (account_id, ledger_id) REFERENCES accounts(id, ledger_id)
            SQL
      end
      dir.down do
        execute <<-SQL
              ALTER TABLE transactions
                DROP CONSTRAINT fk_tx_on_acc_id_lid_refs_acc_on_acc_id_lid
            SQL
      end
    end
  end
end
