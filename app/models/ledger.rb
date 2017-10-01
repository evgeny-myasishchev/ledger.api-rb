# frozen_string_literal: true

class Ledger < ApplicationRecord
  include Loggable

  has_many :accounts

  def create_account!(params)
    account = accounts.build params
    account.display_order = accounts.calculate('maximum', 'display_order') + 1 if account.display_order.blank?
    logger.info 'Creating a new account', account.attributes
    account.save!
    account
  end
end
