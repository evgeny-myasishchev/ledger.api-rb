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

  describe 'report_transaction!' do
    let(:user) { build(:user) }
    let(:account) { create(:account) }

    it 'should should add new transaction object' do
      transaction = build(:transaction, account: account)
      account.report_transaction! user, transaction.attributes.except('ledger_id')

      reported = Transaction.find transaction.id
      expect(reported.account_id).to eql account.id
      expect(reported.reported_user_id).to eql user.user_id
      expect(reported).to eql transaction
    end

    it 'should should return transaction' do
      transaction = build(:transaction, account: account)
      ret = account.report_transaction! user, transaction.attributes
      expect(transaction).to eql(ret)
    end

    describe 'DEBIT' do
      it 'should subtract amount from balance' do
        transaction = build(:transaction, account: account, type_id: Transaction::DEBIT.name, is_pending: false)
        balance_before = account.balance
        pending_before = account.pending_balance
        account.report_transaction! user, transaction.attributes
        account.reload
        expect(account.balance).to eql balance_before - transaction.amount
        expect(account.pending_balance).to eql pending_before
      end

      it 'should also subtract from pending balance for pending transactions' do
        transaction = build(:transaction, account: account, type_id: Transaction::DEBIT.name, is_pending: true)
        balance_before = account.balance
        pending_before = account.pending_balance
        account.report_transaction! user, transaction.attributes
        account.reload
        expect(account.balance).to eql balance_before - transaction.amount
        expect(account.pending_balance).to eql pending_before - transaction.amount
      end
    end

    describe 'CREDIT' do
      it 'should should add amount to balance' do
        transaction = build(:transaction, account: account, type_id: Transaction::CREDIT.name, is_pending: false)
        balance_before = account.balance
        pending_before = account.pending_balance
        account.report_transaction! user, transaction.attributes
        account.reload
        expect(account.balance).to eql balance_before + transaction.amount
        expect(account.pending_balance).to eql pending_before
      end

      it 'should also add to pending balance for pending transactions' do
        transaction = build(:transaction, account: account, type_id: Transaction::CREDIT.name, is_pending: true)
        balance_before = account.balance
        pending_before = account.pending_balance
        account.report_transaction! user, transaction.attributes
        account.reload
        expect(account.balance).to eql balance_before + transaction.amount
        expect(account.pending_balance).to eql pending_before + transaction.amount
      end
    end
  end

  describe 'associations' do
    it 'should belong to ledger' do
      ledger = create(:ledger)
      account = create(:account, ledger: ledger)
      expect(account.ledger).to eql ledger
    end

    it 'should belong to category' do
      ledger = create(:ledger)
      category = create(:account_category, ledger: ledger)
      account = create(:account, ledger: ledger, category: category)
      expect(account.category).to eql category
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
