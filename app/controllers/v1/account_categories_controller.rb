# frozen_string_literal: true

module V1
  class AccountCategoriesController < ApplicationController
    before_action -> { @ledger = current_user.ledgers.find params[:ledger_id] }, only: %i[index create]

    require_scopes :index, ['read:account-categories']
    def index
      categories = @ledger.account_categories
      respond_to do |format|
        format.json { render json: categories }
      end
    end

    require_scopes :create, ['write:account-categories']
    def create
      category_params = create_params(params)
      category = @ledger.create_account_category! category_params
      respond_to do |format|
        format.json { render json: category, status: :created }
      end
    end

    private def create_params(params)
      ActiveModelSerializers::Deserialization.jsonapi_parse! params
    end
  end
end
