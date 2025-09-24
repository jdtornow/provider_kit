# frozen_string_literal: true

require "rails_helper"

describe ProviderKit::NullProvider do

  subject { Item.new(provider: :null) }

  describe "#provider" do
    it "is a null provider" do
      expect(subject.provider.null?).to eq(true)
      expect(subject.provider.capable_of?(:subscriptions, :get)).to eq(false)
    end
  end

end
