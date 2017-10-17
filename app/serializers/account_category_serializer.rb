# frozen_string_literal: true

class AccountCategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :display_order
end
