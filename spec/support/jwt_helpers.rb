# frozen_string_literal: true

module JwtHelpers
  def generate_rsa_private(key_sise: 512)
    OpenSSL::PKey::RSA.generate key_sise
  end

  def create_x509_cert(subject: "/C=BE/O=Test/OU=Test/CN=#{Faker::Internet.domain_name}",
                       not_before: Time.now - 1000,
                       not_after: Time.now + 1000,
                       public_key: generate_rsa_private.public_key,
                       sign_key: generate_rsa_private)
    cert = OpenSSL::X509::Certificate.new
    cert.subject = cert.issuer = OpenSSL::X509::Name.parse(subject)
    cert.not_before = not_before
    cert.not_after = not_after
    cert.public_key = public_key
    cert.sign sign_key, OpenSSL::Digest::SHA1.new
    cert
  end

  def x509_to_pkix(cert)
    cert.to_s
        .gsub("-----BEGIN CERTIFICATE-----\n", '')
        .gsub("\n-----END CERTIFICATE-----\n", '')
  end

  def stub_jwks_endpoint(cert = create_x509_cert)
    response = {
      keys: [
        { kid: "kid1-#{Faker::Lorem.word}", x5c: [x509_to_pkix(cert)] },
        { kid: "kid2-#{Faker::Lorem.word}", x5c: [x509_to_pkix(create_x509_cert)] },
        { kid: "kid3-#{Faker::Lorem.word}", x5c: [x509_to_pkix(create_x509_cert)] }
      ]
    }
    stub_request(:get, URI("https://#{Rails.application.secrets.auth0_domain}/.well-known/jwks.json")).to_return(body: response.to_json)
    response[:keys]
  end

  def create_jwt_token(kid, private_key, iss: nil, aud: nil, exp: Time.now.to_i + 1000, scope: nil)
    payload = {
      'aud' => aud || Rails.application.secrets.auth0_api_audience,
      'iss' => iss || "https://#{Rails.application.secrets.auth0_domain}/",
      'sub' => Faker::Internet.email,
      'exp' => exp,
      'scope' => scope
    }
    [payload, JWT.encode(payload, private_key, 'RS256', kid: kid)]
  end
end
