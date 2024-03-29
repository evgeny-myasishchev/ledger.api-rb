# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V2::Ledgers', type: :request do
  include JsonApiSerialize
  include AuthHelpers

  describe 'GET /v2/ledgers' do
    it_behaves_like 'authorized action', :get,
                    path: { helper: :v2_ledgers_path },
                    permitted_scopes: 'read:ledgers'

    it 'should return ledgers for given user' do
      user = build(:user)
      create_list(:ledger, 5) # Seed
      ledgers = create_list(:ledger, 5)
      ledgers.each { |l| LedgerUser.create!(ledger_id: l.id, user_id: user.user_id) }

      get v2_ledgers_path, with_valid_auth_header(scope: 'read:ledgers', sub: user.user_id)
      expect(response).to have_http_status(200)

      expected_response = json_api_serialize(ledgers)
      expect(JSON.parse(response.body)).to eql(expected_response)
    end
  end

  describe 'POST /v2/ledgers' do
    it_behaves_like 'authorized action', :post,
                    path: { helper: :v2_ledgers_path },
                    permitted_scopes: 'write:ledgers'

    it 'should create a new ledger for given user' do
      ledger_user = create(:ledger_user)
      ledger = build(:ledger, 'created_user_id' => ledger_user.user_id)
      json = json_api_serialize(ledger).as_json.with_indifferent_access
      post v2_ledgers_path, with_valid_auth_header(scope: 'write:ledgers', sub: ledger_user.user_id).merge(params: json)
      expected_response = json_api_serialize(ledger)
      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body)).to eql(expected_response)

      db_ledger = Ledger.find ledger.id
      expect(db_ledger.attributes.except('created_at', 'updated_at')).to eql(ledger.attributes.except('created_at', 'updated_at'))
    end
  end
end
