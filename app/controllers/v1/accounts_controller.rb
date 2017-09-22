# frozen_string_literal: true

module V1
  class AccountsController < ApplicationController
    def index
      accounts = Account.all
      respond_to do |format|
        format.json { render json: accounts }
      end
    end
  end
end
