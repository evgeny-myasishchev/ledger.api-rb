# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Ledgers', type: :request do
  include JsonApiSerialize
  include AuthHelpers

  describe 'GET /v1/ledgers' do
    # it_behaves_like 'authorized action', :get, :v1_ledgers_path, 'read:ledgers'

    it 'should return ledgers for given user' do
      user = build(:user)
      create_list(:ledger, 5) # Seed
      ledgers = create_list(:ledger, 5)
      ledgers.each { |l| LedgerUser.create!(ledger_id: l.id, user_id: user.user_id) }

      get v1_ledgers_path, with_valid_auth_header(scope: 'read:ledgers', sub: user.user_id)
      expect(response).to have_http_status(200)

      expected_response = json_api_serialize(ledgers)
      expect(response.body).to eql(expected_response.to_json)
    end
  end
end
