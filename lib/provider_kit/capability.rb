# frozen_string_literal: true

module ProviderKit
  class Capability

    attr_reader :key, :provider

    def initialize(key, target_klass, provider: nil, **options)
      @key          = key
      @target_klass = target_klass.to_s
      @options      = options || {}
      @provider     = provider
      @context      = options.delete(:context)
    end

    def callable?(method_name)
      callable_methods.include?(method_name.to_s)
    end

    def method_missing(method_name, *args, **kwargs)
      case method_name.to_s
      when /(.+)\?$/
        call($1, *args, **kwargs) == true
      else
        call(method_name, *args, **kwargs)
      end
    end

    def with_context(provider: @provider, **context)
      Capability.new(
        key,
        @target_klass,
        provider: provider.with_context(**context),
        **options.merge(context:)
      )
    end

    private

      attr_reader :context
      attr_reader :options

      def call(method_name, *args, **kwargs)
        call_target = target
        return nil unless call_target
        return nil unless callable?(method_name)

        raw_response = call_target.public_send(method_name, *args, **kwargs)

        case raw_response
        when Hash
          format_response_hash(raw_response)
        when Array
          raw_response.map { |h| format_response_hash(h) }
        else
          raw_response
        end
      end

      # Creates a safe list of methods that can be called on the target
      # Only those methods that were defined in the class are valid
      def callable_methods
        @callable_methods ||= begin
          blacklist = Object.public_instance_methods
          whitelist = target.class.public_instance_methods - blacklist

          Set.new(whitelist.map(&:to_s))
        end
      end

      def format_response_hash(raw_response)
        return raw_response unless raw_response.is_a?(Hash)

        klass = ProviderKit.config.capability_response_format
        klass = Settings if klass == :object

        if klass.is_a?(Class)
          klass.new(raw_response)
        else
          raw_response
        end
      end

      def prepare_target
        klass = @target_klass

        if String === klass
          klass = klass.safe_constantize
        end

        unless klass.respond_to?(:new)
          raise ProviderKit::InvalidCapability.new("Invalid capability class: #{ @target_klass }")
        end

        klass
      end

      def target_class
        @target = nil unless Rails.application.config.cache_classes
        @target ||= prepare_target
      end

      def target
        unless target_class.included_modules.include?(CapabilityExtension)
          target_class.send(:include, CapabilityExtension)
        end

        instance = if options.present?
          target_class.new(options)
        else
          target_class.new
        end

        instance.instance_variable_set("@context", context)
        instance.instance_variable_set("@provider", provider)

        instance
      end

  end
end
