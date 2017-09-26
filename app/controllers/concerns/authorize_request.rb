# frozen_string_literal: true

module AuthorizeRequest
  extend ActiveSupport::Concern

  included do
    include ActionController::HttpAuthentication::Token::ControllerMethods
  end

  def authenticate(request)
    token, _options = ActionController::HttpAuthentication::Token.token_and_options request
    raise Errors::UnauthorizedRequestError, 'No Bearer token found in Authorization header' if token.blank?
    JsonWebToken.verify token
  end

  def authorize(token_payload, permitted_scopes)
    granted_scopes = token_payload['scope'].split(' ')
    missing_scopes = permitted_scopes - granted_scopes
    return if missing_scopes.empty?

    logger.info 'Authorization failed', granted_scopes: granted_scopes, permitted_scopes: permitted_scopes, missing_scopes: missing_scopes
    raise Errors::ForbiddenRequestError, "Authorization failed. Permitted scopes: #{permitted_scopes.join(', ')}"
  end

  module ClassMethods
    def require_scopes(action, permitted_scopes)
      handle = lambda { |controller|
        token_payload = authenticate controller.request
        authorize(token_payload, permitted_scopes)
        logger.info "Request authorized. Subject: #{token_payload['sub']}"
      }
      before_action handle, only: [action]
    end
  end
end
