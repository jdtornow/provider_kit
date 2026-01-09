# frozen_string_literal: true

require "provider_kit/engine"
require "provider_kit/exceptions"
require "provider_kit/version"
require "active_support/dependencies/autoload"
require "zeitwerk"

loader = Zeitwerk::Loader.new
path = File.expand_path(File.join(File.dirname(__FILE__), "provider_kit"))

loader.push_dir(path)
loader.ignore(File.expand_path(path, "generators"))
loader.setup

module ProviderKit

  extend ActiveSupport::Autoload

  ## Config
  eager_autoload do
    autoload :Buildable
    autoload :Registerable
  end

  ## Core
  autoload :Attribute
  autoload :Callbacks
  autoload :Configuration
  autoload :EncryptedSettings
  autoload :Encryptor
  autoload :Execution
  autoload :JsonClient
  autoload :JsonRequest
  autoload :Logging
  autoload :NullProvider
  autoload :Provideable
  autoload :Provider
  autoload :ProviderAttribute
  autoload :Settings

  ## Third-party API setup
  autoload :Capability
  autoload :CapabilityExtension
  autoload :Capable
  autoload :Context
  autoload :Registration

  ## Set up extensions for this module
  extend Registerable
  extend Buildable

  ## Config

  def self.config
    @@config ||= Configuration.new
  end

  def self.configure(&)
    yield config
  end

  # this is just a placeholder for integrations that do not need a custom provider
  register :null, class_name: "ProviderKit::NullProvider"

end
