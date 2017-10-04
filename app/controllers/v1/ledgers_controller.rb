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
  end
end
