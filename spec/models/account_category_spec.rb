# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountCategory, type: :model do
  describe 'create' do
    it 'should save a new category' do
      created = create(:account_category)
      db_rec = AccountCategory.find(created.id)
      expect(db_rec.attributes).to eql(created.attributes)
    end
  end

  describe 'associations' do
    it 'should belong to ledger' do
      ledger = create(:ledger)
      created = create(:account_category, ledger: ledger)
      expect(created.ledger).to eq ledger
    end
  end
end
