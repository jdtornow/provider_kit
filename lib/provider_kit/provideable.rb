# frozen_string_literal: true

module ProviderKit
  # Shortcut for passing an object into a provider
  module Provideable

    extend ActiveSupport::Concern
    include Attribute

    included do
      validate :validate_provider_presence
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
