# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Accounts', type: :request do
  before(:each) do
    DB.client[:accounts].drop
  end

  describe 'GET /v1/accounts' do
    it 'should return accounts' do
      accounts = create_list(:create_account, 5).map(&:as_json)
      get v1_accounts_path(format: :json)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eql(accounts)
    end
  end
end
