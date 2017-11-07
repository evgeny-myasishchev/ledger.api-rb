# frozen_string_literal: true

module V2
  class AccountsController < ApplicationController
    require_scopes :index, ['read:accounts']
    before_action -> { @ledger = current_user.ledgers.find params[:ledger_id] }, only: %i[index create]

    def index
      accounts = @ledger.accounts
      respond_to do |format|
        format.json { render json: accounts }
      end
    end

    require_scopes :create, ['write:accounts']
    def create
      account_params = create_params(params)
      account = @ledger.create_account! current_user, account_params
      respond_to do |format|
        format.json { render json: account, status: :created }
      end
    end

    private

    def create_params(params)
      ActiveModelSerializers::Deserialization.jsonapi_parse! params
    end
  end
end
