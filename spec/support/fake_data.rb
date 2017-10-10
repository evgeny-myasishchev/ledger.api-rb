# frozen_string_literal: true

module FakeData
  def fake_string(prefix = nil, length: 20)
    prefix ? "#{prefix}-#{SecureRandom.hex(length)}" : SecureRandom.hex(length)
  end
  module_function :fake_string

  def pick_one(*array)
    array.flatten[rand(array.length)]
  end
  module_function :pick_one
end

RSpec.configure do |config|
  config.include FakeData
end
