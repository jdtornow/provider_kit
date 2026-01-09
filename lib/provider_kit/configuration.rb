# frozen_string_literal: true

module ProviderKit
  class Configuration

    attr_accessor :capability_response_format
    attr_accessor :credentials_key
    attr_accessor :registered_providers
    attr_accessor :type_defaults

    # default config
    def initialize
      @registered_providers         = {}
      @capability_response_format   = :object
      @type_defaults                = {}
      @credentials_key              = nil
    end

  end
end
