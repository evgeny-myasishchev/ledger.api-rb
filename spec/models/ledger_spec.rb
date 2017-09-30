# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ledger, type: :model do
  it 'should save a new ledger' do
    ledger = create(:ledger)
    created = Ledger.find(ledger.id)
    expect(created.attributes).to eql(ledger.attributes)
  end

  describe 'associations' do
    it 'should have many accounts' do
      ledger = create(:ledger)
      accounts = create_list(:account, 5, ledger: ledger)
      create_list(:account, 5)
      expect(ledger.accounts.to_a).to eql accounts
    end
  end
end
