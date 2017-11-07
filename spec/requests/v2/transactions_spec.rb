# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V2::Transactions', type: :request do
  include JsonApiSerialize
  include AuthHelpers
  include MatchingLedgerHelpers

  describe 'GET /v2/accounts/:account_id/transactions' do
    it_behaves_like 'authorized action', :get,
                    path: { helper: :v2_account_transactions_path, account_id: 'fake' },
                    permitted_scopes: 'read:transactions'

    it 'should return account transactions' do
      ledger_user = create(:ledger_user)
      ledger = ledger_user.ledger
      account = create(:account, ledger: ledger)
      transactions = create_list(:transaction, 5, ledger: ledger, account: account)
      get v2_account_transactions_path(account_id: account.id), with_valid_auth_header(scope: 'read:transactions', sub: ledger_user.user_id)
      expect(response).to have_http_status(200)

      expected_response = json_api_serialize(transactions, each_serializer: TransactionSerializer)
      response_data = JSON.parse(response.body)
      expect(response_data['data']).to eql(expected_response['data'])
      expect(response_data&.[]('meta')&.[]('total_count')).to eql(transactions.length)
    end

    it 'should paginate' do
      ledger_user = create(:ledger_user)
      ledger = ledger_user.ledger
      tags = create_list(:tag, 3, ledger: ledger)
      account = create(:account, ledger: ledger)
      transactions = create_list(:transaction, 10, ledger: ledger, account: account, tags: tags)
      get v2_account_transactions_path(account_id: account.id),
          with_valid_auth_header(scope: 'read:transactions', sub: ledger_user.user_id)
        .merge(params: { page: { offset: 6, limit: 3 } })
      expect(response).to have_http_status(200)

      expected_response = json_api_serialize(transactions[6..8], each_serializer: TransactionSerializer)
      response_data = JSON.parse(response.body)
      expect(response_data['data'].size).to eql(3)
      expect(response_data['data']).to eq(expected_response['data'])
      expect(response_data&.[]('meta')&.[]('total_count')).to eql(transactions.length)
    end

    it 'should fail with 404 if ledger is not shared with user' do
      ledger_user = create(:ledger_user)
      account = create(:account)
      get v2_account_transactions_path(account_id: account.id), with_valid_auth_header(scope: 'read:transactions', sub: ledger_user.user_id)
      should_fail_with_ledger_not_found(response, account)
    end
  end

  describe 'POST /v2/accounts/:account_id/transactions' do
    it_behaves_like 'authorized action', :post,
                    path: { helper: :v2_account_transactions_path, account_id: 'fake' },
                    permitted_scopes: 'write:transactions'

    it 'should report new transaction' do
      ledger_user = create(:ledger_user)
      ledger = ledger_user.ledger
      account = create(:account, ledger: ledger)
      transaction = build(:transaction, account: account)
      json = json_api_serialize(transaction).as_json.with_indifferent_access
      post v2_account_transactions_path(account_id: account.id),
           with_valid_auth_header(scope: 'write:transactions', sub: ledger_user.user_id).merge(params: json)
      created = Transaction.find transaction.id
      transaction.created_at = created.created_at
      transaction.updated_at = created.updated_at
      transaction.reported_user_id = ledger_user.user_id
      expect(created.attributes).to eql transaction.attributes
      expect(response.body).to eql(json_api_serialize(created).to_json)
    end

    it 'should report new transaction with tags' do
      ledger_user = create(:ledger_user)
      ledger = ledger_user.ledger
      tags = create_list(:tag, 3, ledger: ledger)
      account = create(:account, ledger: ledger)
      transaction = build(:transaction, account: account, tags: tags)
      json = json_api_serialize(transaction).as_json.with_indifferent_access
      post v2_account_transactions_path(account_id: account.id),
           with_valid_auth_header(scope: 'write:transactions', sub: ledger_user.user_id).merge(params: json)
      created = Transaction.find transaction.id
      transaction.created_at = created.created_at
      transaction.updated_at = created.updated_at
      transaction.reported_user_id = ledger_user.user_id
      expect(created.tags).to eq tags
      expect(created.attributes).to eql transaction.attributes
      expect(response.body).to eql(json_api_serialize(created).to_json)
    end
  end
end
