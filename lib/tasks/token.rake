# frozen_string_literal: true

namespace :token do
  desc 'Verify JWT token'
  task :verify_jwt_token, [:encoded_token] do |_t, a|
    encoded_token = a.encoded_token
    raise 'Please provide encoded_token' unless encoded_token
    payload = JsonWebToken.verify encoded_token
    Rails.logger.info 'Token verified', payload: payload
  end
end
