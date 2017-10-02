# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Accounts', type: :request do
  include JsonApiSerialize
  include AuthHelpers

  describe 'GET /v1/accounts' do
    it_behaves_like 'authorized action', :get, :v1_accounts_path, 'read:accounts'

    it 'should return accounts' do
      accounts = create_list(:account, 5)
      get v1_accounts_path, with_valid_auth_header(scope: 'read:accounts')
      expect(response).to have_http_status(200)

      expected_response = json_api_serialize(accounts)
      expect(response.body).to eql(expected_response.to_json)
    end
  end

  describe 'POST /v1/accounts' do
    it_behaves_like 'authorized action', :post, :v1_accounts_path, 'write:accounts'

    it 'should create a new account' do
      ledger_user = create(:ledger_user)
      account = build(:account, ledger: ledger_user.ledger, created_user_id: ledger_user.user_id)
      json = json_api_serialize(account).as_json.with_indifferent_access
      post v1_accounts_path, with_valid_auth_header(scope: 'write:accounts', sub: ledger_user.user_id).merge(params: json)
      expected_response = json_api_serialize(account)
      expect(response).to have_http_status(201)
      expect(response.body).to eql(expected_response.to_json)

      db_account = Account.find account.id
      expect(db_account.attributes).to eql(account.attributes)
    end

    it 'should create a new account without an id' do
      account = build(:account)
      json_data = json_api_serialize(account).as_json
      json_data[:data].delete(:id)
      post v1_accounts_path, with_valid_auth_header(scope: 'write:accounts', sub: account.created_user_id).merge(params: json_data)
      expect(response).to have_http_status(201)

      db_account = Account.find_by name: account.name
      account.id = db_account.id
      expect(db_account.attributes).to eql(account.attributes)

      expected_response = json_api_serialize(account)
      expect(response.body).to eql(expected_response.to_json)
    end
  end
end
