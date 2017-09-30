# frozen_string_literal: true

class Currency
  # Numeric code of the currency
  attr_reader :id

  # Alpha code of the currency
  attr_reader :code

  # English name of the currency
  attr_reader :english_name

  attr_reader :unit

  def initialize(attribs)
    @english_name = get_required_attrib attribs, :english_name
    @code = get_required_attrib attribs, :code
    @id = get_required_attrib attribs, :id
    @unit = attribs[:unit] if attribs[:unit]
  end

  def ==(other)
    english_name == other.english_name &&
      code == other.code &&
      id == other.id &&
      unit == other.unit
  end

  def eql?(other)
    self == other
  end

  def to_s
    if unit.nil? || unit.blank?
      "numeric code: #{id}, alpha_code: #{code}, english_name: #{english_name}"
    else
      "numeric code: #{id}, alpha_code: #{code}, english_name: #{english_name}, unit: #{unit}"
    end
  end

  private

  def get_required_attrib(attribs, key)
    raise ArgumentError, "#{key} attribute is missing." if !attribs.key?(key) || attribs[key].blank?
    attribs[key]
  end

  class << self
    def store
      Rails.application.config.currencies_store
    end

    def known?(code)
      currencies_by_code.key?(code)
    end

    def known
      currencies_by_code.values.dup
    end

    def [](code)
      get_by_code code
    end

    # Get the currency instance by alpha code
    def get_by_code(code)
      raise ArgumentError, "#{code} is unknown currency." unless known?(code)
      currencies_by_code[code]
    end

    # Register the currency with specified attributes
    def register(attribs)
      currency = Currency.new(attribs)
      raise ArgumentError, "currency #{currency.code} already registered." if known?(currency.code)
      currencies_by_code[currency.code] = currency
    end

    def clear!
      currencies_by_code.clear
    end

    def save(backup_id)
      backups_by_id[backup_id] = currencies_by_code.dup
    end

    def restore(backup_id)
      raise ArgumentError, "there is no such backup #{backup_id}" unless backups_by_id.key?(backup_id)
      store[:currencies_by_code] = backups_by_id[backup_id]
    end

    private

    def currencies_by_code
      store[:currencies_by_code] ||= {}
    end

    def backups_by_id
      store[:backups_by_id] ||= {}
    end
  end
end
