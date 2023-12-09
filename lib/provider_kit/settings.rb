# frozen_string_literal: true

module ProviderKit
  # Serializable object to read/write from account settings fields
  class Settings

    attr_reader :data

    def initialize(raw_data)
      @data = build_data(raw_data)&.symbolize_keys || {}
    end

    def [](key)
      data[key]
    end

    def []=(key, value)
      data[key] = value
    end

    def include?(key)
      data.include?(key)
    end

    def inspect
      @data.inspect
    end

    def method_missing(method_name, *args)
      super if data.nil?

      # some_key => :value
      if match = method_name.to_s.match(/^(?<attribute>[a-z0-9_]+)$/)
        key = match[:attribute].to_sym

        if Hash === data[key]
          self.class.new(data[key])
        else
          data[key]
        end

      # some_key = "value"
      elsif match = method_name.to_s.match(/^(?<attribute>[a-z0-9_]+)=$/)
        key = match[:attribute].to_sym

        data[key] = args.first

      # some_key? => true/false
      elsif match = method_name.to_s.match(/^(?<attribute>[a-z0-9_]+)\?$/)
        key = match[:attribute].to_sym

        data.has_key?(key) && (data[key] == true || data[key] == "1")
      end
    end

    # always yes so this gets picked up by `method_missing`
    def respond_to?(_)
      true
    end

    def update(value = {})
      existing = (data.presence || {}).symbolize_keys
      value = value.try(:to_h) if value.respond_to?(:to_h)
      value = nil unless value.is_a?(Hash)
      value = {} unless value.present?
      value = value.symbolize_keys

      updated = existing.merge(value)

      @data = build_data(updated)
    end

    def to_h
      data.presence || {}
    end

    def to_json
      if data.present?
        data.to_json
      end
    end

    def self.dump(data)
      case data
      when self
        data.to_json
      else
        new(data).to_json
      end
    end

    def self.load(data = nil)
      new(data.presence || {})
    end

    class Jsonb < self

      def to_json
        if data.present?
          data
        end
      end

    end

    private

      def build_data(data)
        hash = if Settings === data
          data.data
        elsif Hash === data
          data
        else
          JSON.parse(data)
        end

        clean_values(hash)
      rescue StandardError => e
        Rails.logger.error "Error loading Settings #{ e.message }"

        {}
      end

      def clean_array_value(value)
        value.map do |item|
          if String === item && item =~ /^{(.*?)}$/
            JSON.parse(item).symbolize_keys rescue item
          else
            item
          end
        end
      end

      def clean_hash_value(key, value)
        if value.nil?
          nil
        elsif key.to_s.ends_with?("_id") && value.to_s.strip =~ /^\d*$/
          value.to_i
        elsif value.to_s.strip =~ /^\d+$/ && value.to_s.strip.size < 8
          value.to_i
        elsif value.is_a?(String)
          value.to_s.strip.presence

        # Money duck type without requiring Money gem here
        elsif value.respond_to?(:cents) && value.respond_to?(:currency)
          value
        elsif value.to_s.strip =~ /^\d+\.\d+$/
          BigDecimal(value)
        elsif value == "1" || value == "true"
          true
        elsif value == "0" || value == "false"
          false
        elsif Array === value
          clean_array_value(value)
        else
          value
        end
      end

      # make true/false values consistent from forms
      def clean_values(hash)
        hash.reduce({}) do |result, (key, value)|
          result[key] = clean_hash_value(key, value)
          result
        end
      end

  end
end
