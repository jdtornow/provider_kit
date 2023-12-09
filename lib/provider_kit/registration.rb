# frozen_string_literal: true

module ProviderKit
  class Registration

    attr_reader :key
    attr_reader :options

    def initialize(key, **options)
      @key      = key

      if options[:type]
        @types = Array(options.delete(:type)).flatten.compact.presence
      end

      if options[:types]
        @types = Array(options.delete(:types)).flatten.compact.presence
      end

      @options  = options
    end

    def class_name
      options[:class_name].presence || "#{ key.to_s.classify }::Provider"
    end

    def config
      @config ||= Settings.load(options)
    end

    def credentials
      @credentials ||= Settings.load(Rails.application.credentials.dig(:providers, key)&.to_h)
    end

    def display_key
      config.short_key.presence || key
    end

    def disallow_in_test_env?
      options[:test] == false
    end

    def klass
      if Rails.application.config.cache_classes
        @klass ||= build_klass_from_name
      else
        build_klass_from_name
      end
    end

    # generic? => (types.include?(:generic))
    def method_missing(method_name)
      if match = method_name.to_s.match(/^(?<attribute>[a-z0-9_]+)\?$/)
        types.include?(match[:attribute].to_sym)
      end
    end

    def name
      options[:name].presence || key.to_s.titleize
    end

    def provider
      ProviderKit::Provider.new(key).provider_instance
    end

    def types
      @types ||= [ :generic ]
    end

    def valid?
      if disallow_in_test_env? && Rails.env.test?
        return false
      end

      true
    end

    private

      def build_klass_from_name
        if klass = class_name.to_s.safe_constantize
          klass.key = key if klass.respond_to?(:key=)
          klass
        end
      end

  end
end
