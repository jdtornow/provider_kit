# frozen_string_literal: true

module StripeProvider
  class Creds

    def client_id
      nil
    end

    def client_secret
      credentials.secret_key
    end

  end
end
