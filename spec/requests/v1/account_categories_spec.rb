# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::AccountCategories', type: :request do
  include JsonApiSerialize
  include AuthHelpers

  describe 'GET /v1/ledgers/:ledger_id/accounts/categories' do
    it_behaves_like 'authorized action', :get, :v1_account_categories_path, 'read:account-categories'

    it 'should return account-categories' do
      accounts = create_list(:account_category, 5)
      get v1_account_categories_path, with_valid_auth_header(scope: 'read:account-categories')
      expect(response).to have_http_status(200)

      expected_response = json_api_serialize(accounts)
      expect(response.body).to eql(expected_response.to_json)
    end
  end
end
