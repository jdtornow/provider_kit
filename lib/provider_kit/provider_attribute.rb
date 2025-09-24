# frozen_string_literal: true

module ProviderKit
  # serializer for a provider attribute turned into a Provider instance
  class ProviderAttribute

    include Buildable

    ATTRIBUTE_QUERY = /^(?<attribute>[a-z0-9_]+)\?$/.freeze

    attr_reader :key
    attr_reader :record
    attr_reader :context

    def initialize(key, record: nil, **context)
      @key      = (key.to_s.presence || "default").to_sym
      @record   = record
      @context  = context.reverse_merge(default_context)
    end

    def ==(other_key)
      to_s == other_key.to_s
    end

    def inspect
      @key.inspect
    end

    def method_missing(method_name, *args)
      return super unless provider.present?

      if provider.respond_to?(method_name)
        return provider.public_send(method_name, *args)
      end

      # self.amazon_selling_partner? ==> self.key == :amazon_selling_partner
      if match = method_name.to_s.match(ATTRIBUTE_QUERY)
        return match[:attribute].to_clean_sym == key
      end

      provider.with_context(**context).public_send(method_name, *args)
    end

    def respond_to_missing?(method_name, include_private = false)
      return super unless provider.present?

      # Check if the provider responds to the method
      return true if provider.respond_to?(method_name, include_private)

      # Match dynamic `attribute?` methods
      return true if method_name.to_s.match?(ATTRIBUTE_QUERY)

      # Check if the provider with context responds to the method
      return true if provider.with_context(**context).respond_to?(method_name, include_private)

      super
    end

    def label
      name
    end

    def name
      registration&.name.presence || key.to_s.titleize
    end

    def options
      registration&.options.presence || {}
    end

    def present?
      provider.present?
    end

    def registration
      if present?
        ProviderKit.registrations[key.to_sym]
      end
    end

    def to_s
      key.to_s
    end

    def with_context(**context)
      @context = context
      self
    end

    def self.dump(instance)
      case instance
      when self
        instance.to_s
      else
        new(instance).to_s
      end
    end

    def self.load(str)
      new(str)
    end

    private

      def default_context
        _context = {}
        _context[record.model_name.param_key.to_sym] = record if record.present?
        _context
      end

      def provider
        @provider ||= with(key)
      end

  end
end
