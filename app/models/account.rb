# frozen_string_literal: true

class Account
  include Mongoid::Document
  field :name, type: String
end
