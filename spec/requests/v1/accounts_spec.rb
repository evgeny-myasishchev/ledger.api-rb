# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Accounts', type: :request do
  include JsonApiSerialize
  include JwtHelpers

  before(:each) do
    Mongoid.default_client[:accounts].drop
  end

  def with_invalid_auth_header
    keys = stub_jwks_endpoint
    _payload, encoded_token = create_jwt_token keys[0][:kid], generate_rsa_private
    { headers: { Authorization: "Bearer #{encoded_token}" } }
  end

  def with_valid_auth_header(scope: nil)
    private_key = generate_rsa_private
    cert = create_x509_cert public_key: private_key.public_key, sign_key: private_key

    keys = stub_jwks_endpoint cert
    _payload, encoded_token = create_jwt_token keys[0][:kid], private_key, scope: scope
    { headers: { Authorization: "Bearer #{encoded_token}" } }
  end

  describe 'GET /v1/accounts' do
    it 'should return accounts' do
      accounts = create_list(:account, 5)
      get v1_accounts_path, with_valid_auth_header(scope: 'read:accounts')
      expect(response).to have_http_status(200)

      expected_response = json_api_serialize(accounts)
      expect(response.body).to eql(expected_response.to_json)
    end

    it 'should respond with 401 if no auth header' do
      get v1_accounts_path
      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body))
        .to eql('errors' => [
                  { 'code' => 'Unauthorized', 'status' => 401, 'title' => 'No Bearer token found in Authorization header' }
                ])
    end

    it 'should respond with 401 if not a bearer token' do
      get v1_accounts_path, headers: { Authorization: 'Basic fake' }
      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body))
        .to eql('errors' => [
                  { 'code' => 'Unauthorized', 'status' => 401, 'title' => 'No Bearer token found in Authorization header' }
                ])
    end

    it 'should respond with 401 if token verification fails' do
      get v1_accounts_path, with_invalid_auth_header
      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body))
        .to eql('errors' => [
                  { 'code' => 'Unauthorized', 'status' => 401, 'title' => 'Token verification failed: Signature verification raised' }
                ])
    end

    it 'should respond with 403 if bad scopes' do
      get v1_accounts_path, with_valid_auth_header(scope: 'not-read:accounts')
      expect(response).to have_http_status(403)
      expect(JSON.parse(response.body))
        .to eql('errors' => [
                  { 'code' => 'Forbidden', 'status' => 403, 'title' => 'Authorization failed. Permitted scopes: read:accounts' }
                ])
    end
  end

  describe 'POST /v1/accounts' do
    it 'should create a new account' do
      account = build(:account)
      post v1_accounts_path, with_valid_auth_header(scope: 'write:accounts').merge(params: json_api_serialize(account).as_json)
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
      post v1_accounts_path, with_valid_auth_header(scope: 'write:accounts').merge(params: json_data)
      expect(response).to have_http_status(201)

      db_account = Account.find_by name: account.name
      account.id = db_account.id
      expect(db_account.attributes).to eql(account.attributes)

      expected_response = json_api_serialize(account)
      expect(response.body).to eql(expected_response.to_json)
    end
  end
end
