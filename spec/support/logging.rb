# frozen_string_literal: true

RSpec.configure do |config|
  include Loggable
  config.before(:each) do |example|
    logger.info('============================================================')
    logger.info('=== Starting test "' + example.full_description + '" ===')
    logger.info('============================================================')
  end

  config.after(:example) do |example|
    logger.info('===========================================================================')
    logger.info("Spec #{example.exception.nil? ? 'passed' : 'failed'}: #{example.full_description}")
    logger.error(example.exception) if example.exception
    logger.info('===========================================================================')
  end
end
