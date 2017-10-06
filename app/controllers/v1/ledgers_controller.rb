# frozen_string_literal: true

module V1
  class LedgersController < ApplicationController
    require_scopes :index, ['read:ledgers']
    def index
      ledgers = current_user.ledgers
      respond_to do |format|
        format.json { render json: ledgers }
      end
    end

    require_scopes :create, ['write:ledgers']
    def create
      ledger_params = create_params(params)
      ledger = current_user.create_ledger! ledger_params
      respond_to do |format|
        format.json { render json: ledger, status: :created }
      end
    end

    private

    def create_params(params)
      ActiveModelSerializers::Deserialization.jsonapi_parse! params
    end
  end
end
