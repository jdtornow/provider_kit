# frozen_string_literal: true

require "rails_helper"

describe ProviderKit::Attribute do

  let(:item) { Item.new }

  describe "#provider" do
    it "can be mixed in to add optional provider support" do
      expect(item.provider).to be_nil
      expect(item).to be_valid
    end

    it "provides provider details" do
      item.provider = :stripe
      expect(item.provider).to eq(:stripe)
      expect(item.provider.name).to eq("Stripe")
      expect(item.provider.label).to eq("Stripe")
    end
  end

end
