# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::AccountCategories', type: :request do
  include JsonApiSerialize
  include AuthHelpers
  include MatchingLedgerHelpers

  describe 'GET /v1/ledgers/:ledger_id/accounts-categories' do
    it_behaves_like 'authorized action', :get,
                    path: { helper: :v1_ledger_account_categories_path, ledger_id: 'fake' },
                    permitted_scopes: 'read:account-categories'

    it 'should return account-categories' do
      ledger_user = create(:ledger_user)
      ledger = ledger_user.ledger
      categories = create_list(:account_category, 5, ledger: ledger)
      get v1_ledger_account_categories_path(ledger_id: ledger.id), with_valid_auth_header(scope: 'read:account-categories', sub: ledger_user.user_id)
      expect(response).to have_http_status(200)

      expected_response = json_api_serialize(categories)
      expect(response.body).to eql(expected_response.to_json)
    end

    it 'should fail with 404 if ledger is not shared with user' do
      ledger_user = create(:ledger_user)
      ledger = create(:ledger)
      get v1_ledger_account_categories_path(ledger_id: ledger.id), with_valid_auth_header(scope: 'read:account-categories', sub: ledger_user.user_id)
      should_fail_with_ledger_not_found(response, ledger)
    end
  end

  describe 'POST /v1/ledgers/:ledger_id/accounts-categories' do
    it_behaves_like 'authorized action', :post,
                    path: { helper: :v1_ledger_account_categories_path, ledger_id: 'fake' },
                    permitted_scopes: 'write:account-categories'

    it 'should fail with 404 if ledger is not shared with user' do
      ledger_user = create(:ledger_user)
      account_category = build(:account_category)
      json = json_api_serialize(account_category).as_json.with_indifferent_access
      post v1_ledger_account_categories_path(ledger_id: account_category.ledger_id),
           with_valid_auth_header(scope: 'write:account-categories', sub: ledger_user.user_id).merge(params: json)
      should_fail_with_ledger_not_found(response, account_category.ledger)
    end

    it 'should create a new category' do
      ledger_user = create(:ledger_user)
      account_category = build(:account_category, id: 10, ledger: ledger_user.ledger) # id has to be here to have it serialized
      json = json_api_serialize(account_category).as_json.with_indifferent_access
      json['data'].delete 'id'
      post v1_ledger_account_categories_path(ledger_id: account_category.ledger_id),
           with_valid_auth_header(scope: 'write:account-categories', sub: ledger_user.user_id).merge(params: json)
      response_json = JSON.parse response.body
      account_category.id = response_json['data']['id']
      expected_response = json_api_serialize(account_category)
      expect(response).to have_http_status(201)
      expect(response.body).to eql(expected_response.to_json)

      db_category = AccountCategory.find account_category.id
      expect(db_category.attributes).to eql(account_category.attributes)
    end
  end
end
