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

end
