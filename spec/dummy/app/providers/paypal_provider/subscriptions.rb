# frozen_string_literal: true

module PaypalProvider
  class Subscriptions

    def create(customer_id:, price_id:)
      # Create a new subscription in PayPal ...

      {
        id: "pp_sub_123",
        customer_id:,
        price_id:,
        status: "active",
      }
    end

    def get(id:)
      # Get the subscription from PayPal ...

      {
        id: "pp_sub_123",
        customer_id: "pp_cus_123",
        price_id: "pp_price_123",
        status: "active",
      }
    end

    def exists(id:)
      # Check if the subscription exists in PayPal ...

      true
    end

    def update(id:, price_id:)
      # Update the subscription in PayPal ...

      {
        id: "pp_sub_123",
        customer_id: "pp_cus_123",
        price_id:,
        status: "active",
      }
    end

    def cancel(id:)
      # Cancel the subscription in PayPal ...

      {
        id: "pp_sub_123",
        customer_id: "pp_cus_123",
        price_id: "pp_price_123",
        status: "canceled"
      }
    end

  end
end
