# frozen_string_literal: true

require "rails_helper"

describe ProviderKit::Registerable do

  describe ".register" do
    after do
      ProviderKit.deregister :dummy
    end

    it "registers a provider by key" do
      expect {
        ProviderKit.register :dummy
      }.to change {
        ProviderKit.providers.size
      }
      expect(ProviderKit.registrations.keys).to include(:dummy)
    end

    it "registers a provider with some options" do
      expect(ProviderKit.registrations.keys).to_not include(:dummy)

      ProviderKit.register :dummy, name: "Dummy", secret_value: "TKTK"

      expect(ProviderKit.registrations.keys).to include(:dummy)
      expect(ProviderKit.registrations[:dummy]).to be_present
      expect(ProviderKit.registrations[:dummy].name).to eq("Dummy")
      expect(ProviderKit.registrations[:dummy].options[:secret_value]).to eq("TKTK")
    end

    it "contains credentials access" do
      expect(ProviderKit.registrations[:stripe]).to be_present
      expect(ProviderKit.registrations[:stripe].credentials.secret_key).to eq("sk_test_123")

      expect(ProviderKit.registrations[:paypal]).to be_present
      expect(ProviderKit.registrations[:paypal].credentials.client_id).to eq("tktk")
      expect(ProviderKit.registrations[:paypal].credentials.client_secret).to eq("sec_123")
    end
  end

end
