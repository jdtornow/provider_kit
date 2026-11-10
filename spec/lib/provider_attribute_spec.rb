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

    it "is defined directly rather than forwarded through method_missing" do
      attribute = described_class.new(:stripe)

      expect(described_class.public_method_defined?(:as_json, false)).to eq(true)
      expect(attribute).not_to receive(:method_missing)
      attribute.as_json
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

end
