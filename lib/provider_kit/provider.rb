# frozen_string_literal: true

module ProviderKit
  # Given an object, try and find its registered data provider
  #
  # Or directly pass a provider key
  class Provider

    attr_reader :record

    def initialize(record)
      @record = record
    end

    def key
      record_provider.presence || record_source.presence
    end

    def present?
      provider.present?
    end

    def provider
      return nil unless registration

      registration.klass
    end

    def provider_instance
      return nil unless provider

      instance = provider.new

      if instance.respond_to?(:context=) && record != key
        instance.context = record
      end

      instance
    end

    def registration
      if key.present?
        ProviderKit.registrations[key.to_sym]
      end
    end

    private

      def record_provider
        if record.respond_to?(:provider)
          record.provider
        end
      end

      def record_source
        if Symbol === record
          record
        end
      end

  end
end
