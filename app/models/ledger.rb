# frozen_string_literal: true

class Ledger < ApplicationRecord
  has_many :accounts
end
