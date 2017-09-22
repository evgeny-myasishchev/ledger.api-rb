# frozen_string_literal: true

module V1
  class AccountsController < ApplicationController
    def index
      accounts = Account.all
      respond_to do |format|
        format.json { render json: accounts }
      end
    end

    def create
      account = Account.create! create_params
      respond_to do |format|
        format.json { render json: account }
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
