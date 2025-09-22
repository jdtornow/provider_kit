# frozen_string_literal: true

module PaypalProvider
  class Creds

    def client_id
      credentials.client_id
    end

    def client_secret
      credentials.client_secret
    end

  end
end
