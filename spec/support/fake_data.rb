# frozen_string_literal: true

module FakeData
  def fake_string(prefix = nil, length: 20)
    prefix ? "#{prefix}-#{SecureRandom.hex(length)}" : SecureRandom.hex(length)
  end
  module_function :fake_string
end

RSpec.configure do |config|
  config.include FakeData
end
