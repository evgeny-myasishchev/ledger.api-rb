# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V2::Tags', type: :request do
  include JsonApiSerialize
  include AuthHelpers
  include MatchingLedgerHelpers

  describe 'GET /v2/ledgers/:ledger_id/tags' do
    it_behaves_like 'authorized action', :get,
                    path: { helper: :v2_ledger_tags_path, ledger_id: 'fake' },
                    permitted_scopes: 'read:tags'

    it 'should return tags' do
      ledger_user = create(:ledger_user)
      ledger = ledger_user.ledger
      tags = create_list(:tag, 5, ledger: ledger)
      get v2_ledger_tags_path(ledger_id: ledger.id), with_valid_auth_header(scope: 'read:tags', sub: ledger_user.user_id)
      expect(response).to have_http_status(200)

      expected_response = json_api_serialize(tags)
      expect(response.body).to eql(expected_response.to_json)
    end

    it 'should fail with 404 if ledger is not shared with user' do
      ledger_user = create(:ledger_user)
      ledger = create(:ledger)
      get v2_ledger_tags_path(ledger_id: ledger.id), with_valid_auth_header(scope: 'read:tags', sub: ledger_user.user_id)
      should_fail_with_ledger_not_found(response, ledger)
    end
  end

  describe 'POST /v2/ledgers/:ledger_id/tags' do
    it_behaves_like 'authorized action', :post,
                    path: { helper: :v2_ledger_tags_path, ledger_id: 'fake' },
                    permitted_scopes: 'write:tags'

    it 'should fail with 404 if ledger is not shared with user' do
      ledger_user = create(:ledger_user)
      tag = build(:tag)
      json = json_api_serialize(tag).as_json.with_indifferent_access
      post v2_ledger_tags_path(ledger_id: tag.ledger_id),
           with_valid_auth_header(scope: 'write:tags', sub: ledger_user.user_id).merge(params: json)
      should_fail_with_ledger_not_found(response, tag.ledger)
    end

    it 'should create a new tag' do
      ledger_user = create(:ledger_user)
      tag = build(:tag, id: 10, ledger: ledger_user.ledger) # id has to be here to have it serialized
      json = json_api_serialize(tag).as_json.with_indifferent_access
      json['data'].delete 'id'
      post v2_ledger_tags_path(ledger_id: tag.ledger_id),
           with_valid_auth_header(scope: 'write:tags', sub: ledger_user.user_id).merge(params: json)
      response_json = JSON.parse response.body
      tag.id = response_json['data']['id']
      expected_response = json_api_serialize(tag)
      expect(response).to have_http_status(201)
      expect(response.body).to eql(expected_response.to_json)

      db_tag = Tag.find tag.id
      expect(db_tag.attributes).to eql(tag.attributes)
    end
  end
end
