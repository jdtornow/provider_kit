# frozen_string_literal: true

require File.expand_path("../lib/provider_kit/version", __FILE__)

Gem::Specification.new do |s|
  s.name          = "provider_kit"
  s.version       = ProviderKit::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = [ "John D. Tornow" ]
  s.email         = [ "john@johntornow.com" ]
  s.summary       = "A generic interface for dealing with third-party data providers and APIs."
  s.description   = "A generic interface for dealing with third-party data providers and APIs."
  s.license       = "MIT"
  s.files         = Dir.glob("{app,config,db,lib}/**/*") + %w( README.md Rakefile )
  s.require_paths = %w( lib )

  s.required_ruby_version     = ">= 2.6.6"
  s.required_rubygems_version = ">= 1.8.11"

  s.add_dependency "rails", "~> 7.0"
  s.add_dependency "zeitwerk", "~> 2.2"

  s.add_development_dependency "rspec-rails", "~> 4.0"
  s.add_development_dependency "factory_bot_rails", "~> 5.1"
  s.add_development_dependency "shoulda-matchers", "~> 4.2"
  s.add_development_dependency "simplecov", "~> 0.11"
  s.add_development_dependency "rspec_junit_formatter", "~> 0.2"
  s.add_development_dependency "appraisal"
end
