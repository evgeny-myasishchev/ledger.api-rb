# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Accounts', type: :request do
  include JsonApiSerialize
  include AuthHelpers
  include MatchingLedgerHelpers

  describe 'GET /v1/ledgers/:ledger_id/accounts' do
    it_behaves_like 'authorized action', :get,
                    path: { helper: :v1_ledger_accounts_path, ledger_id: 'fake' },
                    permitted_scopes: 'read:accounts'

    it 'should return accounts' do
      ledger_user = create(:ledger_user)
      accounts = create_list(:account, 5, ledger: ledger_user.ledger)
      create_list(:account, 5) # seed
      get v1_ledger_accounts_path(ledger_id: ledger_user.ledger_id), with_valid_auth_header(scope: 'read:accounts', sub: ledger_user.user_id)
      expect(response).to have_http_status(200)

      expected_response = json_api_serialize(accounts)
      expect(response.body).to eql(expected_response.to_json)
    end

    it 'should fail with 404 if ledger is not shared with user' do
      ledger_user = create(:ledger_user)
      ledger = create(:ledger)
      get v1_ledger_accounts_path(ledger_id: ledger.id), with_valid_auth_header(scope: 'read:accounts', sub: ledger_user.user_id)
      should_fail_with_ledger_not_found(response, ledger)
    end
  end

  describe 'POST /v1/ledgers/:ledger_id/accounts' do
    it_behaves_like 'authorized action', :post,
                    path: { helper: :v1_ledger_accounts_path, ledger_id: 'fake' },
                    permitted_scopes: 'write:accounts'

    it 'should fail with 404 if ledger is not shared with user' do
      ledger_user = create(:ledger_user)
      account = build(:account)
      json = json_api_serialize(account).as_json.with_indifferent_access
      post v1_ledger_accounts_path(ledger_id: account.ledger_id),
           with_valid_auth_header(scope: 'write:accounts', sub: ledger_user.user_id).merge(params: json)
      should_fail_with_ledger_not_found(response, account.ledger)
    end

    it 'should create a new account' do
      ledger_user = create(:ledger_user)
      account = build(:account, ledger: ledger_user.ledger, created_user_id: ledger_user.user_id)
      json = json_api_serialize(account).as_json.with_indifferent_access
      post v1_ledger_accounts_path(ledger_id: ledger_user.ledger_id),
           with_valid_auth_header(scope: 'write:accounts', sub: ledger_user.user_id).merge(params: json)
      expected_response = json_api_serialize(account)
      expect(response).to have_http_status(201)
      expect(response.body).to eql(expected_response.to_json)

      db_account = Account.find account.id
      expect(db_account.attributes).to eql(account.attributes)
    end

    it 'should create a new account without an id' do
      ledger_user = create(:ledger_user)
      account = build(:account, created_user_id: ledger_user.user_id)
      json_data = json_api_serialize(account).as_json
      json_data[:data].delete(:id)
      post v1_ledger_accounts_path(ledger_id: ledger_user.ledger_id),
           with_valid_auth_header(scope: 'write:accounts', sub: ledger_user.user_id).merge(params: json_data)
      expect(response).to have_http_status(201)

      db_account = Account.find_by name: account.name
      account.id = db_account.id
      account.ledger_id = ledger_user.ledger_id
      expect(db_account.attributes).to eql(account.attributes)

      expected_response = json_api_serialize(account)
      expect(response.body).to eql(expected_response.to_json)
    end
  end
end
