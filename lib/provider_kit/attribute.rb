# frozen_string_literal: true

module ProviderKit
  # serialized attribute for provider
  module Attribute

    extend ActiveSupport::Concern

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

  end
end
