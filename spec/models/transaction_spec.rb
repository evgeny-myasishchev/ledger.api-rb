# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'validation' do
    it 'should restrict type to debit or credit' do
      bad_type = FakeData.fake_string 'bad-type'
      transaction = build(:transaction, type_id: bad_type)
      expect do
        transaction.validate!
      end.to raise_error ActiveRecord::RecordInvalid, 'Validation failed: Type is not included in the list'
    end
  end

  describe 'create' do
    it 'should save new transaction' do
      rec = create(:transaction)
      db_rec = Transaction.find rec.id
      expect(rec.attributes).to eql db_rec.attributes
    end

    it 'should save new transaction with custom id' do
      id = SecureRandom.uuid
      rec = create(:transaction, id: id)
      db_rec = Transaction.find id
      expect(rec.attributes).to eql db_rec.attributes
    end
  end

  describe 'associations' do
    it 'should belong to account' do
      account = create(:account)
      transaction = create(:transaction, account: account, ledger: account.ledger)
      expect(transaction.account).to eql account
    end

    it 'should belong to ledger' do
      ledger = create(:ledger)
      transaction = create(:transaction, ledger: ledger)
      expect(transaction.ledger).to eql ledger
    end
  end

  describe 'constraints' do
    it 'should restrict using account from a different ledger' do
      bad_account = create(:account)
      transaction = create(:transaction)
      transaction.account_id = bad_account.id
      expect { transaction.save! }.to raise_error ActiveRecord::InvalidForeignKey, /fk_tx_on_acc_id_lid_refs_acc_on_acc_id_lid/
    end
  end
end
