# frozen_string_literal: true

module V1
  class AccountsController < ApplicationController
    def index
      accounts = DB.find('accounts').map { |a| Account.new(a) }
      respond_to do |format|
        format.json { render json: accounts, adapter: :json_api }
      end
    end
  end
end
