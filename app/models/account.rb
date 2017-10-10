# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :ledger
  has_many :transactions

  before_create do
    self.id = SecureRandom.uuid unless id
  end
end
