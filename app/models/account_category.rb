# frozen_string_literal: true

class AccountCategory < ApplicationRecord
  belongs_to :ledger
  has_many :accounts
end
