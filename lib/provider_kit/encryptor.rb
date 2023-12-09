# frozen_string_literal: true

module ProviderKit
  # Wrapper around ActiveSupport::MessageEncryptor with a shared credential key
  class Encryptor

    def decrypt(encrypted_value, purpose: :provider)
      crypt.decrypt_and_verify(encrypted_value, purpose:)
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      nil
    end

    def encrypt(raw_value, purpose: :provider)
      crypt.encrypt_and_sign(raw_value, purpose:)
    end

    def self.shared
      @shared ||= new
    end

    private

      def crypt
        @crypt ||= ActiveSupport::MessageEncryptor.new(key)
      end

      def key
        ProviderKit.config.credentials_key.byteslice(0, 32)
      end

  end
end
