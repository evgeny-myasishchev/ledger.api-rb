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
      account = Account.create! create_params
      respond_to do |format|
        format.json { render json: account, status: :created }
      end
    end

    private

    def create_params
      account_params = params.require(:data).require(:attributes).permit(:name)
      account_params[:id] = params[:data][:id] if params[:data].key?(:id)
      account_params
    end
  end
end
