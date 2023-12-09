# frozen_string_literal: true

module ProviderKit
  # Designed to add provider utility methods to module
  module Context

    extend ActiveSupport::Concern

    class_methods do

      def capabilities
        provider.capabilities.keys
      end

      def capable_of?(thing, method_name = nil)
        provider.capable_of?(thing, method_name)
      end

      def config
        provider_registration.config
      end

      def credentials
        provider_registration.credentials
      end

      def method_missing(method_name, **kwargs)
        if capable_of?(method_name)
          return provider.perform_capability(method_name, **kwargs)
        end

        super
      end

      def provider
        @provider ||= ProviderKit.with(provider_key)
      end

      def provider_key
        @provider_key ||= self.to_s.underscore.gsub(/_provider$/, "").to_sym
      end

      def provider_registration
        ProviderKit.registrations[provider_key]
      end

      def provider_types
        provider_registration.types
      end

      def with_context(**kwargs)
        provider.with_context(**kwargs)
      end

    end

  end
end
