# frozen_string_literal: true

module V1
  class AccountsController < ApplicationController
    require_scopes :index, ['read:accounts']
    def index
      accounts = Account.all
      respond_to do |format|
        format.json { render json: accounts }
      end
    end

    require_scopes :create, ['write:accounts']
    def create
      account_params = create_params(params)
      ledger = Ledger.find account_params[:ledger_id]
      # TODO: Eusure user is authorized with that ledger
      account = ledger.create_account! current_user, account_params
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
