# frozen_string_literal: true

module ProviderKit
  # Designed to add registration methods to the core namespace
  module Registerable

    def deregister(key)
      if registrations[key]
        config.registered_providers.delete(key)
      end
    end

    def for(type)
      if env_key = ENV["PROVIDER_FOR_#{ type.upcase }"].presence
        registrations[env_key.to_s.strip.downcase.to_sym].klass
      elsif default_key = config.type_defaults[type].presence
        registrations[default_key].klass
      else
        providers(type:).last
      end
    end

    # special provider for placeholders
    def null
      ProviderKit.registrations[:null].klass
    end

    def providers(type: nil)
      registrations(type:).values.map(&:klass)
    end

    # ProviderKit.register :stripe
    def register(key, **options)
      registration = Registration.new(key, **options)
      return false unless registration.valid?

      deregister(key)

      config.registered_providers[key] = registration
    end

    def registrations(type: nil)
      if type.present?
        config.registered_providers.select { |_, reg| reg.types.include?(type) }
      else
        config.registered_providers
      end
    end

    def use(key, **options)
      type = options[:for] || options[:type]

      config.type_defaults[type] = key
    end

  end
end
