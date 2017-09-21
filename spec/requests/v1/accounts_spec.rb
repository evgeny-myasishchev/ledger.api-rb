# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Accounts', type: :request do
  before(:each) do
    Mongoid.default_client[:accounts].drop
  end

  describe 'GET /v1/accounts' do
    it 'should return accounts' do
      accounts = create_list(:account, 5)
      get v1_accounts_path(format: :json)
      expect(response).to have_http_status(200)

      expected_response = ActiveModelSerializers::SerializableResource.new(accounts, adapter: :json_api)
      expect(response.body).to eql(expected_response.to_json)
    end
  end
end
