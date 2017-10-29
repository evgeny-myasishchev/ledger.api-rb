# frozen_string_literal: true

class Transaction < ApplicationRecord
  # http://www.ldoceonline.com/dictionary/debit
  # debit - to take money out of a bank account
  DEBIT = TransactionType::Debit.new

  # http://www.ldoceonline.com/dictionary/credit
  # credit - to add money to a bank account
  CREDIT = TransactionType::Credit.new

  TYPES_BY_ID = begin
    index = Hash.new { |_hash, type_id| raise StandardError, "Unexpected type #{type_id}" }
    index[DEBIT.name] = DEBIT
    index[CREDIT.name] = CREDIT
    index
  end

  belongs_to :account, optional: true
  belongs_to :ledger
  has_many :transaction_tags
  has_many :tags, through: :transaction_tags

  validates :type_id, inclusion: { in: [DEBIT.name, CREDIT.name] }

  def calculate_balance(balance)
    TYPES_BY_ID[type_id].calculate_balance balance, amount
  end
end
