# frozen_string_literal: true

module AuthHelpers
  def self.included(target)
    target.include JwtHelpers
  end

  def with_invalid_auth_header
    keys = stub_jwks_endpoint
    _payload, encoded_token = create_jwt_token keys[0][:kid], generate_rsa_private
    { headers: { Authorization: "Bearer #{encoded_token}" } }
  end

  def with_valid_auth_header(scope: nil)
    private_key = generate_rsa_private
    cert = create_x509_cert public_key: private_key.public_key, sign_key: private_key

    keys = stub_jwks_endpoint cert
    _payload, encoded_token = create_jwt_token keys[0][:kid], private_key, scope: scope
    { headers: { Authorization: "Bearer #{encoded_token}" } }
  end
end
