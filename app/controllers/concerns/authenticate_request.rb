# frozen_string_literal: true

module AuthenticateRequest
  extend ActiveSupport::Concern

  included do
    include ActionController::HttpAuthentication::Token::ControllerMethods

    before_action :authenticate
  end

  def authenticate
    token, _options = ActionController::HttpAuthentication::Token.token_and_options request
    raise Errors::UnauthorizedRequestError, 'No Bearer token found in Authorization header' if token.blank?
    payload = JsonWebToken.verify token
    logger.info "Request authenticated. Subject: #{payload['sub']}"
  end
end
