# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Accounts', type: :request do
  include JsonApiSerialize

  before(:each) do
    Mongoid.default_client[:accounts].drop
  end

  describe 'GET /v1/accounts' do
    it 'should return accounts' do
      accounts = create_list(:account, 5)
      get v1_accounts_path(format: :json)
      expect(response).to have_http_status(200)

      expected_response = json_api_serialize(accounts)
      expect(response.body).to eql(expected_response.to_json)
    end
  end

  describe 'POST /v1/accounts' do
    it 'should create a new account' do
      account = build(:account)
      post v1_accounts_path(format: :json), params: json_api_serialize(account).as_json
      expected_response = json_api_serialize(account)
      expect(response.body).to eql(expected_response.to_json)

      db_account = Account.find account.id
      expect(db_account.attributes).to eql(account.attributes)
    end

    it 'should create a new account without an id' do
      account = build(:account)
      json_data = json_api_serialize(account).as_json
      json_data[:data].delete(:id)
      post v1_accounts_path(format: :json), params: json_data

      db_account = Account.find_by name: account.name
      account.id = db_account.id
      expect(db_account.attributes).to eql(account.attributes)

      expected_response = json_api_serialize(account)
      expect(response.body).to eql(expected_response.to_json)
    end
  end
end
