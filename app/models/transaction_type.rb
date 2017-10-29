# frozen_string_literal: true

module TransactionType
  class Debit
    attr_reader :name
    def initialize
      @name = 'DEBIT'.freeze
    end

    def calculate_balance(balance, amount)
      balance - amount
    end
  end

  class Credit
    attr_reader :name
    def initialize
      @name = 'CREDIT'.freeze
    end

    def calculate_balance(balance, amount)
      balance + amount
    end
  end
end
