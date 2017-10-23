# frozen_string_literal: true

class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :account_id, :reported_user_id,
             :type_id, :amount, :comment, :date,
             :is_refund, :is_transfer, :is_pending,
             :created_at, :updated_at
end
