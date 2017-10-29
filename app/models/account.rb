# frozen_string_literal: true

class Account < ApplicationRecord
  include Loggable

  belongs_to :category,
             optional: true,
             class_name: :AccountCategory,
             foreign_key: :account_category_id
  belongs_to :ledger
  has_many :transactions

  before_create do
    self.id = SecureRandom.uuid unless id
  end

  def report_transaction!(user, params)
    trans = transactions.build params
    trans.reported_user_id = user.user_id
    logger.info "Reporting new transaction id=#{trans.id}, account_id: #{id}, amount: #{trans.amount}, type: #{trans.type_id}"
    self.balance = trans.calculate_balance balance
    logger.info "Account balance changed: #{balance}"
    if trans.is_pending
      self.pending_balance = trans.calculate_balance pending_balance
      logger.info "Account pending balance changed: #{pending_balance}"
    end
    save!
    trans
  end
end
