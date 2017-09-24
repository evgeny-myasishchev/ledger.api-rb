# frozen_string_literal: true

class JsonWebToken
  include Loggable

  class TokenVerificationError < Errors::HttpError
    def initialize(msg)
      super(msg, errors: [{
        status: 401, code: 'Unauthorized', title: msg
      }])
    end
  end

  class << self
    def verify(token)
      JWT.decode(token,
                 nil, # no password
                 true, # Verify the signature of this token
                 algorithm: 'RS256',
                 iss: "https://#{Rails.application.secrets.auth0_domain}/",
                 verify_iss: true,
                 aud: Rails.application.secrets.auth0_api_audience,
                 verify_aud: true) do |header|
        jwks_key(header['kid']).public_key
      end[0]
    rescue JWT::DecodeError => e
      logger.info('Failed to verify token', token: token)
      raise TokenVerificationError, "Token verification failed: #{e.message}"
    end

    def jwks_key(kid)
      # Race condition is not that big issue here as in a worst case we will fetch twice
      @jwks_keys_by_kid ||= {}
      unless @jwks_keys_by_kid.key?(kid)
        jwks_keys = fetch_jwks_keys
        keys_by_kid = map_keys_by_kid jwks_keys
        logger.debug "Fetched jwks keys: #{keys_by_kid.keys}"
        @jwks_keys_by_kid.replace keys_by_kid
      end
      raise TokenVerificationError, "Token verification failed: Unknown kid #{kid}" unless @jwks_keys_by_kid.key?(kid)
      @jwks_keys_by_kid[kid]
    end

    private

    def fetch_jwks_keys
      jwks_url = "https://#{Rails.application.secrets.auth0_domain}/.well-known/jwks.json"
      logger.debug "Fetching jwsk keys from #{jwks_url}"
      jwks_raw = Net::HTTP.get URI(jwks_url)
      Array(JSON.parse(jwks_raw)['keys'])
    end

    def map_keys_by_kid(jwks_keys)
      Hash[
        jwks_keys
        .map do |k|
          [
            k['kid'],
            OpenSSL::X509::Certificate.new(Base64.decode64(k['x5c'].first))
          ]
        end
      ]
    end
  end
end
