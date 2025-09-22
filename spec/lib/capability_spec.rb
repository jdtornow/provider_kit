# frozen_string_literal: true

require "rails_helper"

describe ProviderKit::Capability do

  let(:customer) { Customer.create!(email: "test@example.com") }
  let(:subscription) { Subscription.new(customer:, provider: :stripe, external_key: "sub_123") }

  subject { subscription.provider.subscriptions }

  describe "#call" do
    it "calls the method on the target capability class" do
      expect_any_instance_of(StripeProvider::Subscriptions).to receive(:get).with(id: "sub_123").and_call_original

      expect(subject.get(id: "sub_123")).to be_present
    end

    it "calls the method on the target capability class for a boolean method" do
      expect_any_instance_of(StripeProvider::Subscriptions).to receive(:exists).with(id: "sub_123").and_call_original

      expect(subject.exists?(id: "sub_123")).to be_truthy
    end

    it "allows access to credentials for this provider automatically" do
      expect(subscription.provider.creds).to be_present
      expect(subscription.provider.creds.client_id).to be_nil
      expect(subscription.provider.creds.client_secret).to eq("sk_test_123")

      subscription.provider = :paypal
      expect(subscription.provider.creds).to be_present
      expect(subscription.provider.creds.client_id).to eq("tktk")
      expect(subscription.provider.creds.client_secret).to eq("sec_123")
    end
  end

end
