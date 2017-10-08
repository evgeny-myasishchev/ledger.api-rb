# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ledger, type: :model do
  it 'should save a new ledger' do
    ledger = create(:ledger)
    created = Ledger.find(ledger.id)
    expect(created.attributes).to eql(ledger.attributes)
  end

  it 'should generate new id' do
    ledger = build(:ledger)
    ledger.id = nil
    ledger.save!
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

    it 'should have many ledgers_users' do
      ledger = create(:ledger)
      ledger_users = create_list(:ledger_user, 3, ledger: ledger)
      expect(ledger.ledger_users.to_json).to eql ledger_users.to_json
    end

    it 'should have many account_categories' do
      ledger = create(:ledger)
      account_categories = create_list(:account_category, 3, ledger: ledger)
      expect(ledger.account_categories.to_json).to eql account_categories.to_json
    end
  end

  describe 'create_account!' do
    it 'should create a new account for the ledger' do
      user = build(:user)
      ledger = create(:ledger)
      account_attribs = build(:account, created_user_id: user.user_id).attributes.except('ledger_id')
      account = ledger.create_account! user, account_attribs.except('created_user_id')
      expect(account.attributes).to eql account_attribs.merge 'ledger_id' => ledger.id
      db_account = Account.find(account.id)
      expect(db_account.attributes).to eql account.attributes
    end

    it 'should set display_order to a very last number' do
      user = build(:user)
      ledger = create(:ledger)
      max_account = Array.new(3) { create(:account, ledger: ledger, display_order: rand(100)) }
                         .max_by(&:display_order)
      created_account = ledger.create_account! user, build(:account).attributes.except('display_order')
      expect(created_account.display_order).to be > max_account.display_order
    end

    it 'should set display_order to a one if no accounts yet' do
      user = build(:user)
      ledger = create(:ledger)
      created_account = ledger.create_account! user, build(:account).attributes.except('display_order')
      expect(created_account.display_order).to eql 1
    end
  end

  describe 'create_account_category!' do
    let(:ledger) { create(:ledger) }

    it 'should create a new category for the ledger' do
      attribs = build(:account_category).attributes.except('ledger_id')
      account_category = ledger.create_account_category! attribs
      expect(account_category.attributes).to eql attribs.merge('id' => account_category.id, 'ledger_id' => ledger.id)

      db_rec = AccountCategory.find account_category.id
      expect(db_rec.attributes).to eql account_category.attributes
    end

    it 'should set display_order to a very last number' do
      max_rec = Array.new(3) { create(:account_category, ledger: ledger, display_order: rand(100)) }
                     .max_by(&:display_order)
      created = ledger.create_account_category! build(:account_category).attributes.except('display_order')
      expect(created.display_order).to be > max_rec.display_order
    end

    it 'should set display_order to a one if no records yet' do
      created = ledger.create_account_category! build(:account_category).attributes.except('display_order')
      expect(created.display_order).to eql 1
    end
  end
end
