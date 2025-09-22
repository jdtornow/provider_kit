# frozen_string_literal: true

require "rails_helper"

describe ProviderKit::Provideable do

  let(:customer) { Customer.create!(email: "test@example.com") }
  let(:subscription) { Subscription.new(customer:, provider: :stripe, external_key: "sub_123") }

  describe "#provider" do
    it "has a provider attribute" do
      expect(subscription.provider).to be_present
      expect(subscription.provider).to be_kind_of(ProviderKit::ProviderAttribute)
      expect(subscription.provider.key).to eq(:stripe)
      expect(subscription.external_key).to eq("sub_123")
    end

    it "errors when has a invalid provider value" do
      subscription.provider = :unknown_provider
      expect(subscription.valid?).to be_falsey
      expect(subscription.errors[:provider]).to be_present
    end

    it "errors when has a blank provider value" do
      subscription.provider = nil
      expect(subscription.valid?).to be_falsey
      expect(subscription.errors[:provider]).to be_present
    end

    it "returns the provider attribute when provider is set" do
      subscription.provider = :paypal
      expect(subscription.provider.key).to eq(:paypal)
      expect(subscription.provider.name).to eq("Paypal")
      expect(subscription.provider.subscriptions).to be_kind_of(ProviderKit::Capability)
    end
  end

  describe "#provider=" do
    it "sets the provider attribute" do
      subscription.provider = :paypal
      expect(subscription.provider.key).to eq(:paypal)
      expect(subscription.external_key).to eq("sub_123")
    end
  end

  describe "#provider_key" do
    it "returns the provider key" do
      expect(subscription.provider_key).to eq("stripe")
    end
  end

end
