# frozen_string_literal: true

require 'rails_helper'

describe Account, type: :model do
  describe 'create' do
    it 'should save new account' do
      created_account = create(:account)
      db_account = Account.find(id: created_account.id)
      expect(db_account.name).to eql(created_account.name)
    end
  end
end
