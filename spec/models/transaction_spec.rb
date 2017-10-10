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
      transaction = create(:transaction, account: account)
      expect(transaction.account).to eql account
    end
  end
end
