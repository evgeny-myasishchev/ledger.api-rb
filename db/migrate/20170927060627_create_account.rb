# frozen_string_literal: true

class CreateAccount < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts, id: :string do |t|
      t.string :ledger_id, null: false
      t.string :name, null: false
      t.integer 'display_order', null: false
      t.string 'created_user_id', null: false
      t.integer 'account_category_id'
      t.string  'currency_code', null: false
      t.string  'name', null: false
      t.string  'unit'
      t.integer 'balance', default: 0, null: false
      t.integer 'pending_balance', default: 0, null: false
      t.boolean 'is_closed', null: false, default: false
    end
    add_index(:accounts, %i[id ledger_id], unique: true)
    add_foreign_key :accounts, :ledgers, name: 'fk_accounts_on_ledger_id_refs_ledgers_id'

    reversible do |dir|
      dir.up do
        execute <<-SQL
                  ALTER TABLE accounts
                    ADD CONSTRAINT fk_acc_on_acc_cat_id_lid_refs_acc_cat_on_id_lid
                    FOREIGN KEY (account_category_id,ledger_id) REFERENCES account_categories(id, ledger_id)
                SQL
      end
      dir.down do
        execute <<-SQL
              ALTER TABLE accounts
                DROP CONSTRAINT fk_acc_on_acc_cat_id_lid_refs_acc_cat_on_id_lid
            SQL
      end
    end
  end
end
