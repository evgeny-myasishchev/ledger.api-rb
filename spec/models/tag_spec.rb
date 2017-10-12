# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'create' do
    it 'should save a new tag' do
      created = create(:tag)
      db_rec = Tag.find(created.id)
      expect(db_rec.attributes).to eql(created.attributes)
    end
  end

  describe 'associations' do
    it 'should belong to ledger' do
      ledger = create(:ledger)
      created = create(:tag, ledger: ledger)
      expect(created.ledger).to eq ledger
    end
  end
end
