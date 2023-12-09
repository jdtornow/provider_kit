# frozen_string_literal: true

module ProviderKit
  # Designed to add provider utility methods to module
  module Buildable

    # ProviderKit.with(:stripe).subscriptions.get(id: "123")
    def with(key_or_record)
      provider = ProviderKit::Provider.new(key_or_record)
      return nil unless provider.present?

      provider.provider_instance
    end

  end
end
