# frozen_string_literal: true

class Transaction < ApplicationRecord
  # http://www.ldoceonline.com/dictionary/debit
  # debit - to take money out of a bank account
  DEBIT = 'DEBIT'.freeze

  # http://www.ldoceonline.com/dictionary/credit
  # credit - to add money to a bank account
  CREDIT = 'CREDIT'.freeze

  belongs_to :account

  validates_inclusion_of :type_id, in: [DEBIT, CREDIT]
end
