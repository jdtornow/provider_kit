# ProviderKit

ProviderKit is a simple utility for creating an abstraction layer between various third-party services (usually via API) and your application's code.

It contains some conventions and utilities for making this easier. Think of it as a way to create simple wrappers on top of third-party APIs, but also a way to make those consistent across 'providers' of the same type.

For example, say you support payments from multiple third-party services like Stripe or PayPal. In each of those services we'll need to handle customers, subscriptions, and payments. Here's how we could interface with that using ProviderKit:

```ruby
# customer 1 uses Stripe
user = User.create(provider: :stripe, ...)
user.provider.customers.get(id: user.customer_key) # => { id: "cus_Nff" }

# customer 2 uses PayPal
user2 = User.create(provider: :paypal)
user.provider.customers.get(id: user.customer_key) # => { id: "abc-123" }
```

Then anywhere in your code where you have business logic that requires a customer the code is consistent, but each individual provider contains its custom code to deal with that provider's details. Here's what the 'get customer' logic could look like inside of a provider's configuration:

```ruby
module StripeProvider
  class Customers
    def get(id:)
      stripe_customer = Stripe::Customer.retrieve(id)

      {
        id: stripe_customer.id,
        # ... etc
      }
    end
  end
end
```

This library was originally developed for this exact use case, but we use it for a bunch of different provider types including linking multiple CRM tools, ecommerce providers, and many more.

## Generator

Use the generator to create a new provider:

```bash
rails g provider my_provider_name
```

## Capabilities

Providers have 'capabilities' to determine what types of things they can do. Each provider registers those capabilities within the provider setup itself. For example, the `Customers` class above would likely be registered within the `StripeProvider` like this:

```ruby
module StripeProvider
  class Provider

    include ProviderKit::Capable

    capable_of :subscriptions, with: Customers

  end
end
```

This registration offers some nice reflection methods, so you can determine at runtime which features a particular provider allows. For example, Stripe has a customers [search endpoint](https://docs.stripe.com/api/customers/search) but PayPal does not. So we can build the search feature into `StripeProvider`:

```ruby
module StripeProvider
  class Customers
    def search(query:)
      customers = Stripe::Customer.search(query:)

      customers.map do |customer|
        {
          id: customer.id,
          name: customer.name,
          # ...
        }
      end
    end
  end
end
```

Then we can check it at runtime to make sure the provider is capable of this action:

```ruby
if user.provider.capable_of?(:customers, :search)
  user.customers.search(query: 'john@example.com')
else
  []
end
```

This is a primitive example but it's a powerful concept!

## Credentials

Rails credentials can be used within the context of a provider's capability methods. By convention, store each provider's credentials in this format:

```yaml
# rails credentials:edit

providers:
  provider_name_here:
    secret_key: abc123

  stripe:
    secret_key: sk_1234
```

Then they can be used anywhere in a provider:

```ruby
module StripeProvider
  class Customers
    def get(id:)
      # you probably should put this in an initializer instead
      # so it doesn't need to be in every method,
      # but it does work!
      Stripe.api_key = credentials.secret_key

      # ...
    end
  end
end
```

## A Work In Progress

This gem has been in production since 2019, so it's battle tested, but not very well spec-tested. It's an ongoing work in progress. If you find it helpful, go for it, I'm very open to contributions. But it's presented as-is, and probably won't be very actively maintained other than ensuring it works with new versions of Ruby and Rails.

