# frozen_string_literal: true

class User
  include Loggable

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

  def create_ledger!(params)
    logger.info "Creating new account for user #{user_id}", params
    ledger = Ledger.new params
    ledger.created_user_id = user_id
    ledger.ledger_users.build user_id: user_id, is_owner: true
    ledger.save!
    ledger
  end

  def to_s
    inspect
  end

  def inspect
    "User(#{@token_payload.to_json})"
  end
end
