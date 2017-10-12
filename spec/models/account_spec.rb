# frozen_string_literal: true

require 'rails_helper'

describe Account, type: :model do
  describe 'create' do
    it 'should save new account' do
      created_account = create(:account)
      db_account = Account.find(created_account.id)
      expect(db_account.name).to eql(created_account.name)
    end

    it 'should save new account with custom id' do
      account_id = SecureRandom.uuid
      created_account = create(:account, id: account_id)
      db_account = Account.find(account_id)
      expect(db_account.name).to eql(created_account.name)
    end
  end

  describe 'associations' do
    it 'should belong to ledger' do
      ledger = create(:ledger)
      account = create(:account, ledger: ledger)
      expect(account.ledger).to eql ledger
    end

    it 'have many transactions' do
      account = create(:account)
      transactions = create_list(:transaction, 5, account: account)
      expect(account.transactions.to_json).to eql transactions.to_json
    end

    it 'have many tags' do
      account = create(:account)
      transactions = create_list(:transaction, 5, account: account)
      expect(account.transactions.to_json).to eql transactions.to_json
    end
  end

  describe 'constraints' do
    it 'should restrict assigning category from a different ledger' do
      ledger = create(:ledger)
      bad_ledger_category = create(:account_category)
      account = create(:account, ledger: ledger)
      account.account_category_id = bad_ledger_category.id
      expect { account.save! }.to raise_error ActiveRecord::InvalidForeignKey, /fk_acc_on_acc_cat_id_lid_refs_acc_cat_on_id_lid/
    end
  end
end
