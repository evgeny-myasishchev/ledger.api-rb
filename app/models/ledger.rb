# frozen_string_literal: true

class Ledger < ApplicationRecord
  include Loggable

  has_many :accounts
  has_many :ledger_users

  before_create do
    self.id = SecureRandom.uuid unless id
  end

  def create_account!(user, params)
    account = accounts.build params
    account.created_user_id = user.user_id
    account.display_order = accounts.calculate('maximum', 'display_order') + 1 if account.display_order.blank?
    logger.info 'Creating a new account', account.attributes
    account.save!
    account
  end
end
