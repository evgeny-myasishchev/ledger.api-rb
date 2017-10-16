# frozen_string_literal: true

module ErrorHandler
  extend ActiveSupport::Concern

  included do
    # TODO: ActionController::UnpermittedParameters
    rescue_from Errors::HttpError do |err|
      logger.error('Request failed', errors: err.errors)
      render status: err.status, json: { errors: err.errors }
    end

    rescue_from ActiveRecord::RecordNotFound do |err|
      logger.error('Request failed', errors: [err])
      render status: 404, json: { errors: [
        { code: 'Not Found', status: 404, title: "#{err.model} not found (id=#{err.id})" }
      ] }
    end
  end
end
