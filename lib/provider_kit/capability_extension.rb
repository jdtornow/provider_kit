# frozen_string_literal: true

module ProviderKit
  module CapabilityExtension

    extend ActiveSupport::Concern

    private

      attr_reader :provider
      attr_reader :context

      def config
        provider&.config
      end

      def credentials
        provider&.credentials
      end

  end
end
