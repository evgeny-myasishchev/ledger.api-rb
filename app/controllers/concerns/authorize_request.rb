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
    user = User.new token_payload
    granted_scopes = user.granted_scopes
    missing_scopes = permitted_scopes - granted_scopes
    return user if missing_scopes.empty?
    logger.info 'Authorization failed', granted_scopes: granted_scopes, permitted_scopes: permitted_scopes, missing_scopes: missing_scopes
    raise Errors::ForbiddenRequestError, "Authorization failed. Permitted scopes: #{permitted_scopes.join(', ')}"
  end

  def current_user
    # TODO: Throw UnauthorizedRequestError if not assigned
    request.env['ledger.user']
  end

  module ClassMethods
    def require_scopes(action, permitted_scopes)
      handle = lambda { |controller|
        token_payload = authenticate controller.request
        user = authorize(token_payload, permitted_scopes)
        logger.info "Request authorized. Subject: #{user.user_id}"
        request.env['ledger.user'] = user
      }

      # Has to be the first filter
      prepend_before_action handle, only: [action]
    end
  end
end
