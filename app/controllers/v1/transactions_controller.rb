# frozen_string_literal: true

module V1
  class TransactionsController < ApplicationController
    before_action -> { @account = current_user.accounts.find(params[:account_id]) }, only: %i[index create]

    require_scopes :index, ['read:transactions']
    def index
      transactions = @account.transactions
      respond_to do |format|
        format.json { render json: transactions }
      end
    end
  end
end
