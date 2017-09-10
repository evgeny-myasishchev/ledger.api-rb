# frozen_string_literal: true

module Loggable
  extend ActiveSupport::Concern

  included do
    def logger
      Rails.logger
    end
  end

  class_methods do
    def logger
      Rails.logger
    end
  end
end
