# frozen_string_literal: true

require "active_support"

module ProviderKit
  class Engine < ::Rails::Engine

    isolate_namespace ProviderKit

    engine_name "provider_kit"

    initializer "provider_kit.load_credentials_key" do |app|
      ProviderKit.configure do |config|
        credentials_key = ENV["PROVIDERKIT_KEY"].presence || Rails.application.credentials.secret_key_base.presence || Rails.application.credentials.secret_key_base
        config.credentials_key ||= credentials_key
      end
    end

  end
end
