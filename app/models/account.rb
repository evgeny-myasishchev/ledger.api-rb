# frozen_string_literal: true

class Account < ApplicationRecord
  before_create do
    self.id = SecureRandom.uuid unless id
  end
end
