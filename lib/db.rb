# frozen_string_literal: true

class DB
  class << self
    def find(collection, query)
      client[collection].find(query)
    end

    def client
      @client ||= Mongo::Client.new(Rails.application.config.mongo_url, logger: Rails.logger)
    end
  end
end
