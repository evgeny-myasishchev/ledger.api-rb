# frozen_string_literal: true

class Ledger < ApplicationRecord
  include Loggable

  has_many :accounts
  has_many :ledger_users
  has_many :account_categories

  before_create do
    self.id = SecureRandom.uuid unless id
  end

  def create_account!(user, params)
    # TODO: Raise if category is not from ledger
    account = accounts.build params
    account.created_user_id = user.user_id
    account.display_order = (accounts.calculate('maximum', 'display_order') || 0) + 1 if account.display_order.blank?
    logger.info 'Creating a new account', account.attributes
    account.save!
    account
  end

  def create_account_category!(params)
    category = account_categories.build params
    category.display_order = (account_categories.calculate('maximum', 'display_order') || 0) + 1 if category.display_order.blank?
    logger.info 'Creating a new account category', category.attributes
    category.save!
    category
  end
end
