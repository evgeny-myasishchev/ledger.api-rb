# frozen_string_literal: true

class TransactionTag < ApplicationRecord
  belongs_to :ledger
end
