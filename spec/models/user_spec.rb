# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  describe 'ledgers' do
    it 'should return user ledgers' do
      user = build(:user)
      create_list(:ledger, 5) # Seed
      ledgers = create_list(:ledger, 5)
      ledgers.each { |l| LedgerUser.create!(ledger_id: l.id, user_id: user.user_id) }
      expect(user.ledgers.to_a).to eql ledgers
    end
  end
end
