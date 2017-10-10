# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransactionTag, type: :model do
  describe 'create' do
    it 'should save a new tag' do
      created = create(:transaction_tag)
      db_rec = TransactionTag.find(created.id)
      expect(db_rec.attributes).to eql(created.attributes)
    end
  end

  describe 'associations' do
    it 'should belong to ledger' do
      ledger = create(:ledger)
      created = create(:transaction_tag, ledger: ledger)
      expect(created.ledger).to eq ledger
    end
  end
end
