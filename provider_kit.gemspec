# frozen_string_literal: true

require File.expand_path("../lib/provider_kit/version", __FILE__)

Gem::Specification.new do |s|
  s.name          = "provider_kit"
  s.version       = ProviderKit::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = [ "John D. Tornow" ]
  s.email         = [ "john@johntornow.com" ]
  s.summary       = "A generic interface for dealing with third-party data providers and APIs."
  s.description   = "A generic interface and abstraction layer for dealing with third-party data providers and APIs in Rails. ProviderKit helps you to add a layer between your third-party APIs and internal code."
  s.license       = "MIT"
  s.files         = Dir.glob("{app,config,db,lib}/**/*") + %w( README.md LICENSE Rakefile )
  s.require_paths = %w( lib )
  s.homepage      = "https://github.com/jdtornow/provider_kit"

  s.metadata = {
    "bug_tracker_uri"   => "https://github.com/jdtornow/provider_kit/issues",
    "changelog_uri"     => "https://github.com/jdtornow/provider_kit/releases",
    "homepage_uri"      => "https://github.com/jdtornow/provider_kit"
  }

  s.required_ruby_version     = ">= 3.2"
  s.required_rubygems_version = ">= 1.8.11"

  s.add_dependency "rails", "~> 8.0"
  s.add_dependency "zeitwerk", "~> 2.2"

  s.add_development_dependency "annotaterb", "~> 4.15"
  s.add_development_dependency "factory_bot_rails", "~> 6.5"
  s.add_development_dependency "faker", "~> 3.5"
  s.add_development_dependency "rspec-rails", "~> 8.0"
  s.add_development_dependency "rubocop", "~> 1.76"
  s.add_development_dependency "shoulda-matchers", "~> 6.5"
  s.add_development_dependency "timecop", "~> 0.9"
end
