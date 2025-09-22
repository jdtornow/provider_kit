# frozen_string_literal: true

module StripeProvider
  class Subscriptions

    def create(customer_id:, price_id:)
      # Create a new subscription in Stripe ...

      {
        id: "sub_123",
        customer_id:,
        price_id:,
        status: "active",
      }
    end

    def get(id:)
      # Get the subscription from Stripe ...

      {
        id: "sub_123",
        customer_id: "cus_123",
        price_id: "price_123",
        status: "active",
      }
    end

    def exists(id:)
      # Check if the subscription exists in Stripe ...

      true
    end

    def update(id:, price_id:)
      # Update the subscription in Stripe ...

      {
        id: "sub_123",
        customer_id: "cus_123",
        price_id:,
        status: "active",
      }
    end

    def cancel(id:)
      # Cancel the subscription in Stripe ...

      {
        id: "sub_123",
        customer_id: "cus_123",
        price_id: "price_123",
        status: "canceled",
      }
    end

  end
end
