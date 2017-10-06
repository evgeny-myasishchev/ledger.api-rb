# frozen_string_literal: true

class LedgerSerializer < ActiveModel::Serializer
  attributes :id, :name, :currency_code
end
