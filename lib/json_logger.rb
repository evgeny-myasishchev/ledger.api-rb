# frozen_string_literal: true

class JsonLogger < Ougai::Logger
  include ActiveSupport::LoggerThreadSafeLevel
  include LoggerSilence

  module TaggableFormatter
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

  class JsonBunyanFormatter < Ougai::Formatters::Bunyan
    include TaggableFormatter

    delegate :current_tags, to: :@tagged_formatter

    def initialize(tagged_formatter, log_tag_names, *args)
      super(*args)
      @tagged_formatter = tagged_formatter
      @log_tag_names = log_tag_names
    end
  end

  class PrettyFormatter < Ougai::Formatters::Readable
    include TaggableFormatter

    delegate :current_tags, to: :@tagged_formatter

    def initialize(tagged_formatter, log_tag_names, *args)
      super(*args)
      @tagged_formatter = tagged_formatter
      @log_tag_names = log_tag_names
    end
  end

  def initialize(config)
    @readable_logging = config.readable_logging
    @log_tag_names = config.log_tags
    @tagged_formatter = ActiveSupport::Logger::SimpleFormatter.new
    @tagged_formatter.extend ActiveSupport::TaggedLogging::Formatter

    super(config.log_path)
    after_initialize if respond_to? :after_initialize
  end

  def create_formatter
    if @readable_logging
      PrettyFormatter.new @tagged_formatter, @log_tag_names
    else
      JsonBunyanFormatter.new @tagged_formatter, @log_tag_names
    end
  end

  def tagged(*tags)
    @tagged_formatter ? @tagged_formatter.tagged(*tags) { yield self } : yield(self)
  end
end
