# frozen_string_literal: true

require 'rails_helper'

describe JsonWebToken do
  include JwtHelpers

  describe 'verify' do
    let(:private_key) { generate_rsa_private }
    let(:cert) { create_x509_cert public_key: private_key.public_key, sign_key: private_key }

    it 'should return decoded token' do
      keys = stub_jwks_endpoint cert
      payload, encoded_token = create_jwt_token keys[0][:kid], private_key
      decoded_payload = JsonWebToken.verify encoded_token
      expect(payload).to eql(decoded_payload)
    end

    it 'should raise error if bad signature' do
      keys = stub_jwks_endpoint cert
      _payload, encoded_token = create_jwt_token keys[1][:kid], private_key
      expect do
        JsonWebToken.verify encoded_token
      end.to raise_error JsonWebToken::TokenVerificationError, 'Token verification failed: Signature verification raised'
    end

    it 'should should raise error if bad iss' do
      keys = stub_jwks_endpoint cert
      _payload, encoded_token = create_jwt_token keys[0][:kid], private_key, iss: 'bad-issuer'
      expected_iss = "https://#{Rails.application.secrets.auth0_domain}/"
      expect do
        JsonWebToken.verify encoded_token
      end.to raise_error JsonWebToken::TokenVerificationError,
                         "Token verification failed: Invalid issuer. Expected #{expected_iss}, received bad-issuer"
    end

    it 'should raise error if bad aud' do
      keys = stub_jwks_endpoint cert
      _payload, encoded_token = create_jwt_token keys[0][:kid], private_key, aud: 'bad-aud'
      expected_aud = Rails.application.secrets.auth0_api_audience
      expect do
        JsonWebToken.verify encoded_token
      end.to raise_error JsonWebToken::TokenVerificationError,
                         "Token verification failed: Invalid audience. Expected #{expected_aud}, received bad-aud"
    end

    it 'should raise error if expired' do
      keys = stub_jwks_endpoint cert
      _payload, encoded_token = create_jwt_token keys[0][:kid], private_key, exp: Time.now.to_i - 100
      expect do
        JsonWebToken.verify encoded_token
      end.to raise_error JsonWebToken::TokenVerificationError, 'Token verification failed: Signature has expired'
    end

    it 'should raise error if no such kid' do
      stub_jwks_endpoint cert
      fake_kid = "fake-kid-#{FFaker::Lorem.word}"
      _payload, encoded_token = create_jwt_token fake_kid, private_key
      expect do
        JsonWebToken.verify encoded_token
      end.to raise_error JsonWebToken::TokenVerificationError, "Token verification failed: Unknown kid #{fake_kid}"
    end
  end

  before do
    WebMock.reset!
  end

  describe 'jwks_key' do
    it 'should fetch new jwks keys from the endpoint and return a key' do
      keys = stub_jwks_endpoint
      key1 = JsonWebToken.jwks_key keys[0][:kid]
      expect(key1.to_s).to eql OpenSSL::X509::Certificate.new(Base64.decode64(keys[0][:x5c].first)).to_s
    end

    it 'should keep existing keys cached' do
      keys = stub_jwks_endpoint
      JsonWebToken.jwks_key keys[0][:kid]
      JsonWebToken.jwks_key keys[1][:kid]
      expect(WebMock).to have_requested(:get, URI("https://#{Rails.application.secrets.auth0_domain}/.well-known/jwks.json"))
        .once
    end

    it 'should should update cache if requesting a new key' do
      keys1 = stub_jwks_endpoint
      JsonWebToken.jwks_key keys1[0][:kid]
      keys2 = stub_jwks_endpoint
      key2 = JsonWebToken.jwks_key keys2[0][:kid]
      expect(WebMock).to have_requested(:get, URI("https://#{Rails.application.secrets.auth0_domain}/.well-known/jwks.json"))
        .twice
      expect(key2.to_s).to eql OpenSSL::X509::Certificate.new(Base64.decode64(keys2[0][:x5c].first)).to_s
    end
  end
end
