# frozen_string_literal: true

module ProviderKit
  # Mixin for a model to make it have the provider methods
  module Capable

    extend ActiveSupport::Concern

    included do
      attr_accessor :context

      mattr_accessor :capabilities
      mattr_accessor :key

      self.capabilities ||= {}

      delegate :capable_of?, :perform_capability, to: self
    end

    def config
      registration&.config
    end

    def credentials
      registration&.credentials
    end

    def display_key
      registration&.display_key
    end

    def method_missing(method_name, *args, **kwargs)
      if capable_of?(method_name)
        if kwargs.present?
          perform_capability(method_name).with_context(provider: self, **kwargs)
        else
          perform_capability(method_name).with_context(provider: self, **(context || {}))
        end
      else
        super
      end
    end

    def provider_key
      key
    end

    def with_context(**context)
      self.context = context
      self
    end

    class_methods do

      def capable_of(namespace, with:, **options)
        self.capabilities[namespace.to_sym] = Capability.new(namespace, with, **options)
      end

      def capable_of?(thing, method_name = nil)
        return false unless self.capabilities.has_key?(thing.to_sym)
        return true unless method_name.present?

        capability = capabilities[thing]
        return false unless capability

        capability.callable?(method_name)
      end

      def method_missing(method_name, *args, **kwargs)
        if capable_of?(method_name)
          perform_capability(method_name, *args, **kwargs)
        else
          super
        end
      end

      def perform_capability(name, **kwargs)
        capabilities[name].with_context(provider:, **kwargs)
      end

      def provider
        provider_key = key.presence || module_parent&.provider_key
        ProviderKit.with(provider_key)
      end

      def with_context(**context)
        instance = new()
        instance.context = context
        instance
      end

    end

    private

      def registration
        @registration ||= ProviderKit.registrations[key]
      end

  end
end
