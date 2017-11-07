# frozen_string_literal: true

module V2
  class TransactionsController < ApplicationController
    before_action -> { @account = current_user.accounts.find(params[:account_id]) }, only: %i[index create]

    require_scopes :index, ['read:transactions']
    def index
      page = params.fetch(:page, {})
      limit = page.fetch(:limit, 10)
      offset = page.fetch(:offset, 0)
      transactions = @account.transactions
                             .includes(:tags)
                             .offset(offset)
                             .take(limit)
      respond_to do |format|
        format.json do
          render json: transactions,
                 each_serializer: TransactionSerializer,
                 meta: { total_count: @account.transactions.count }
        end
      end
    end

    require_scopes :create, ['write:transactions']
    def create
      transaction_params = create_params(params)
      trans = @account.report_transaction! current_user, transaction_params
      respond_to do |format|
        format.json { render json: trans, status: :created }
      end
    end

    private def create_params(params)
      ActiveModelSerializers::Deserialization.jsonapi_parse!(params, only: %i[
                                                               id
                                                               type_id
                                                               amount
                                                               comment
                                                               date
                                                               is_refund
                                                               tags
                                                             ])
    end
  end
end
