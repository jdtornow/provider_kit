# frozen_string_literal: true

module ProviderKit
  # Shortcut for passing an object into a provider
  module Provideable

    extend ActiveSupport::Concern

    included do
      validate :validate_provider_presence
    end

    def provider
      if provider_key.present?
        @provider ||= ProviderKit::ProviderAttribute.new(provider_key, record: self)
      end
    end

    def provider=(value)
      @provider = nil

      write_attribute(:provider, value.to_s.presence)
    end

    def provider_key
      read_attribute(:provider).to_s.presence
    end

    private

      def validate_provider_presence
        if provider.present? && provider_key != "default"
          return
        end

        errors.add :provider, :blank
      end

  end
end
