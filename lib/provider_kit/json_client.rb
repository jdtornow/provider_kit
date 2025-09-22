# frozen_string_literal: true

module ProviderKit
  # Generic interface for working with JSON-based APIs.
  #
  # This class is just a simple wrapper around net/http so we don't need
  # to use a third-party networking library for basic stuff.
  class JsonClient

    DEFAULT_HEADERS = {
      "Accept" => "application/json",
      "User-Agent" => "ProviderKitBot/1.0 (+https://example.com)"
    }

    attr_reader :base_url
    attr_reader :default_headers
    attr_reader :default_params
    attr_reader :default_mode

    def initialize(base_url, **options)
      @base_url         = base_url
      @default_headers  = options[:headers].presence || DEFAULT_HEADERS
      @default_params   = options[:params].presence || {}
      @default_mode     = options[:mode].presence || :json
    end

    %w( get post patch put delete ).each do |http_method|
      class_eval <<-CODE, __FILE__, __LINE__ + 1
        def #{ http_method }(path, params: {}, headers: {}, mode: nil)
          req = request(path, method: :#{ http_method }, params: params, headers: headers, mode: mode)
          req.json
        end
      CODE
    end

    def request(path, method: :get, params: {}, headers: {}, mode: nil)
      path      = "/#{ path }".gsub(%r{//}, "/")
      url       = "#{ base_url }#{ path }"
      headers   = default_headers.merge(headers)
      params    = default_params.merge(params)
      mode      = mode.presence || default_mode

      JsonRequest.new(url, method:, params:, headers:, mode:)
    end

    private

      # Provide a generic log subscriber for basic request details.
      #
      # A more detailed log subscriber could be configured to log the request/response data too if needed later
      class LogSubscriber < ActiveSupport::LogSubscriber

        def perform_start(event)
          info do
            request = event.payload[:request]

            "Performing json request (Request ID: #{ request.process_id }) #{ request.method.to_s.upcase } #{ request.url }"
          end
        end

        def perform(event)
          request = event.payload[:request]
          ex = event.payload[:exception_object]

          if ex
            error do
              "Error performing json request (Request ID: #{ request.process_id }) in #{ event.duration.round(2) }ms: #{ ex.class } (#{ ex.message }):\n" + Array(ex.backtrace).join("\n")
            end
          else
            info do
              "Performed json request (Request ID: #{ request.process_id }) in #{ event.duration.round(2) }ms (#{ request.method.to_s.upcase } #{ request.url })"
            end
          end
        end

      end

  end
end

ProviderKit::JsonClient::LogSubscriber.attach_to :provider_kit_json_client
