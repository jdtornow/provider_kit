# frozen_string_literal: true

module ProviderKit
  # Serializable object to read/write from account settings fields (encrypted)
  class EncryptedSettings < Settings

    def to_value
      encrypt_data_for_storage
    end

    def self.dump(data)
      case data
      when self
        data.to_value
      else
        new(data).to_value
      end
    end

    def self.load(data)
      new(data.presence)
    end

    private

      def build_data(data)
        if Hash === data
          data
        elsif decrypted = decrypt_data(data)
          JSON.parse(decrypted)
        end
      end

      def decrypt_data(encrypted_data)
        if encrypted_data.present?
          ProviderKit::Encryptor.shared.decrypt(encrypted_data)
        end
      end

      def encrypt_data_for_storage
        if data.present?
          ProviderKit::Encryptor.shared.encrypt(data.to_json)
        end
      end

  end
end
