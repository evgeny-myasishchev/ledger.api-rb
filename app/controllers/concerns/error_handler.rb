# frozen_string_literal: true

module ErrorHandler
  extend ActiveSupport::Concern

  included do
    # TODO: ActionController::UnpermittedParameters
    rescue_from Errors::HttpError do |err|
      logger.error('Request failed', errors: err.errors)
      render status: err.status, json: { errors: err.errors }
    end
  end
end
