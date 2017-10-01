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

  describe 'create_account!' do
    it 'should create a new account for the ledger' do
      ledger = create(:ledger)
      account_attribs = build(:account).attributes.except 'ledger_id'
      account = ledger.create_account! account_attribs
      expect(account.attributes).to eql account_attribs.merge 'ledger_id' => ledger.id
      db_account = Account.find(account.id)
      expect(db_account.attributes).to eql account.attributes
    end

    it 'should set display_order to a very last number' do
      ledger = create(:ledger)
      max_account = Array.new(3) { create(:account, ledger: ledger, display_order: rand(100)) }
                         .max_by(&:display_order)
      created_account = ledger.create_account! build(:account).attributes.except 'display_order'
      expect(created_account.display_order).to be > max_account.display_order
    end
  end
end
