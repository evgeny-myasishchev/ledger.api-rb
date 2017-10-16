# frozen_string_literal: true

class AccountSerializer < ActiveModel::Serializer
  attributes :id, :name, :display_order, :currency_code, :unit, :balance
end
