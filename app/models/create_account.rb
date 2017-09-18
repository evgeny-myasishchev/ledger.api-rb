# frozen_string_literal: true

class CreateAccount
  include Loggable
  include ActiveModel::Model

  attr_accessor :name

  def process!
    logger.info "Creating new account: #{name}"
    DB.insert_one 'accounts', name: name
  end
end
