# frozen_string_literal: true

require "rails_helper"

describe "ProviderKit" do

  it "has a Rails engine" do
    expect(ProviderKit::Engine).to be_present
    expect(ProviderKit::Engine.ancestors).to include(Rails::Engine)
  end

  it "has a version number" do
    expect(ProviderKit::VERSION).to_not be_nil
  end

  context ".config" do
    it "has config.registered_providers" do
      expect(ProviderKit.config.registered_providers).to be_kind_of(Hash)
      expect(ProviderKit.config.registered_providers.keys).to include(:stripe)
    end

    it "has config.capability_response_format for default format" do
      expect(ProviderKit.config.capability_response_format).to eq(:object)

      ProviderKit.config.capability_response_format = :hash

      expect(ProviderKit.config.capability_response_format).to eq(:hash)

      ProviderKit.config.capability_response_format = :object
    end

    it "has config.type_defaults to override which type of provider should be used by default" do
      expect(ProviderKit.config.type_defaults).to eq({})

      ProviderKit.use(:stripe, for: :billing)

      expect(ProviderKit.for(:billing)).to eq(StripeProvider::Provider)

      expect(ProviderKit.config.type_defaults).to eq({ billing: :stripe })

      ProviderKit.config.type_defaults = {}
    end

    it "has config.credentials_key for referencing rails creds" do
      expect(ProviderKit.config.credentials_key).to be_present
    end
  end

end
