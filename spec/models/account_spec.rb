# frozen_string_literal: true

require 'rails_helper'

describe Account, type: :model do
  describe 'create' do
    it 'should save new account' do
      created_account = create(:account)
      db_account = Account.find(created_account.id)
      expect(db_account.name).to eql(created_account.name)
    end

    it 'should save new account with custom id' do
      account_id = SecureRandom.uuid
      created_account = create(:account, id: account_id)
      db_account = Account.find(account_id)
      expect(db_account.name).to eql(created_account.name)
    end
  end
end
