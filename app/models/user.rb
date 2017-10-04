# frozen_string_literal: true

class User
  attr_reader :user_id, :granted_scopes

  def initialize(token_payload)
    # TODO: Unit test
    raise ArgumentError, 'sub not found within the token' if token_payload['sub'].blank?
    @user_id = token_payload['sub']
    @granted_scopes = token_payload['scope'].split(' ')
    @token_payload = token_payload
  end

  def ledgers
    Ledger.joins(:ledger_users).where(ledger_users: { user_id: user_id })
  end

  def to_s
    inspect
  end

  def inspect
    "User(#{@token_payload.to_json})"
  end
end
