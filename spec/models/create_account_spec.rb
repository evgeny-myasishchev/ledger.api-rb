# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateAccount, type: :model do
  describe 'process' do
    it 'should write a new account into the database' do
      cmd = CreateAccount.new name: Faker::Company.name
      cmd.process!
      account = DB.find('accounts', name: cmd.name).first
      expect(account[:name]).to eq cmd.name
    end
  end
end
