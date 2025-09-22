# frozen_string_literal: true

module StripeProvider
  class Provider

    include ProviderKit::Capable

    capable_of :creds, with: Creds
    capable_of :subscriptions, with: Subscriptions

  end
end
