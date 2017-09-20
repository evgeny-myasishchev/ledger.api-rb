# frozen_string_literal: true

class JsonLogger < Ougai::Logger
  include ActiveSupport::LoggerThreadSafeLevel
  include LoggerSilence

  class TaggedBunyanFormatter < Ougai::Formatters::Bunyan
    delegate :current_tags, to: :@tagged_formatter

    def initialize(tagged_formatter, log_tag_names, *args)
      super(*args)
      @tagged_formatter = tagged_formatter
      @log_tag_names = log_tag_names
    end

    def call(severity, timestamp, progname, msg)
      current_tags = @tagged_formatter.current_tags
      tags = current_tags.map.with_index do |tag_value, index|
        tag_name = @log_tag_names[index]
        [tag_name || "unnamed-#{index}", tag_value]
      end.to_h
      msg = msg.merge tags
      super(severity, timestamp, progname, msg)
    end
  end

  def initialize(log_tag_names, *args)
    @log_tag_names = log_tag_names
    @tagged_formatter = ActiveSupport::Logger::SimpleFormatter.new
    @tagged_formatter.extend ActiveSupport::TaggedLogging::Formatter

    super(*args)
    after_initialize if respond_to? :after_initialize
  end

  def create_formatter
    TaggedBunyanFormatter.new @tagged_formatter, @log_tag_names
  end

  def tagged(*tags)
    @tagged_formatter.tagged(*tags) { yield self }
  end
end
