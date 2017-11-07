# frozen_string_literal: true

module V2
  class TagsController < ApplicationController
    before_action -> { @ledger = current_user.ledgers.find params[:ledger_id] }, only: %i[index create]

    require_scopes :index, ['read:tags']
    def index
      tags = @ledger.tags
      respond_to do |format|
        format.json { render json: tags }
      end
    end

    require_scopes :create, ['write:tags']
    def create
      tag_params = create_params(params)
      category = @ledger.create_tag! tag_params
      respond_to do |format|
        format.json { render json: category, status: :created }
      end
    end

    private def create_params(params)
      ActiveModelSerializers::Deserialization.jsonapi_parse! params
    end
  end
end
