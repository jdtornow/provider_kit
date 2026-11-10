# frozen_string_literal: true

require "rails_helper"

describe ProviderKit::ProviderAttribute do

  describe "#as_json" do
    let(:record_class) do
      Class.new do
        include ActiveModel::Model
        include ActiveModel::Serializers::JSON

        attr_accessor :provider_key

        def self.name
          "SerializedThing"
        end

        def attributes
          { "provider" => nil }
        end

        def provider
          ProviderKit::ProviderAttribute.new(provider_key, record: self)
        end
      end
    end

    it "serializes a registered key to its string" do
      attribute = described_class.new(:stripe)

      expect(attribute.as_json).to eq("stripe")
      expect(attribute.to_json).to eq("\"stripe\"")
    end

    it "serializes an unregistered key to its string" do
      attribute = described_class.new(:not_registered)

      expect(attribute.as_json).to eq("not_registered")
      expect(attribute.to_json).to eq("\"not_registered\"")
    end

    it "serializes a blank key to the default key" do
      attribute = described_class.new(nil)

      expect(attribute.as_json).to eq("default")
    end

    it "serializes to its key when nested in a hash" do
      attribute = described_class.new(:stripe)

      expect({ provider: attribute }.to_json).to eq("{\"provider\":\"stripe\"}")
    end

    it "is defined on the class rather than reached through method_missing" do
      attribute = described_class.new(:stripe)

      expect(attribute.method(:as_json).owner).to eq(described_class)
    end

    it "serializes a record holding one without recursing" do
      record = record_class.new(provider_key: :stripe)

      expect(record.as_json).to eq({ "provider" => "stripe" })
      expect(record.to_json).to eq("{\"provider\":\"stripe\"}")
    end

    it "serializes an ActiveRecord model using ProviderKit::Attribute" do
      item = Item.new(provider: :stripe)

      expect(item.as_json["provider"]).to eq("stripe")
      expect(JSON.parse(item.to_json)["provider"]).to eq("stripe")
    end
  end

  describe ".dump and .load" do
    it "round trips the key string" do
      expect(described_class.dump(described_class.new(:stripe))).to eq("stripe")
      expect(described_class.dump(:stripe)).to eq("stripe")
      expect(described_class.load("stripe")).to eq(:stripe)
    end
  end

end
