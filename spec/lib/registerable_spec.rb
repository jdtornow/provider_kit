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
  end

end
