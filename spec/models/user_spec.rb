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

  describe 'accounts' do
    it 'should return user accounts through ledgers' do
      user = build(:user)
      create_list(:ledger, 2).each do |ledger|
        create_list(:account, 2, ledger: ledger)
      end
      ledgers = create_list(:ledger, 2)
      accounts = ledgers.map do |l|
        LedgerUser.create!(ledger_id: l.id, user_id: user.user_id)
        create_list(:account, 2, ledger: l)
      end.flatten
      expect(user.accounts.to_a).to eql accounts
    end
  end

  describe 'create_ledger!' do
    it 'should create a new ledger for given user' do
      user = build(:user)
      ledger = build(:ledger)
      created = user.create_ledger! ledger.attributes
      expect(created).to be created

      db_ledger = Ledger.find ledger.id
      expect(db_ledger.attributes).to eql ledger.attributes.merge('created_user_id' => user.user_id,
                                                                  'created_at' => db_ledger.created_at,
                                                                  'updated_at' => db_ledger.updated_at)
      ledger_user = db_ledger.ledger_users.find_by_user_id user.user_id
      expect(ledger_user).not_to be_blank
      expect(ledger_user.is_owner).to eql true
    end
  end
end
