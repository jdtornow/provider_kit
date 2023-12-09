# frozen_string_literal: true

module ProviderKit
  # Generic interface for working with http request/response and json
  class JsonRequest

    include ProviderKit::Callbacks
    include ProviderKit::Execution

    attr_reader :url
    attr_reader :method
    attr_reader :params
    attr_reader :headers
    attr_reader :mode
    attr_reader :body
    attr_reader :process_id

    attr_reader :http_request
    attr_reader :http_response

    around_perform do |request, block, _|
      tag_logger(request.process_id) do
        payload = { request: }
        ActiveSupport::Notifications.instrument("perform_start.provider_kit_json_client", payload.dup)
        ActiveSupport::Notifications.instrument("perform.provider_kit_json_client", payload) do
          block.call
        end
      end
    end

    def initialize(url, method: :get, params: {}, headers: {}, mode: :json)
      @url        = url
      @method     = method
      @params     = params
      @headers    = headers
      @mode       = mode
      @process_id = SecureRandom.uuid

      prepare_request
      perform_now
    end

    def json
      JSON.parse(body)
    rescue
      nil
    end

    def success?
      (200..299).include?(status)
    end

    def status
      http_response.code.to_i
    end

    def uri
      @uri ||= URI(url)
    end

    private

      def http
        @http ||= begin
          http = Net::HTTP.new(uri.host, uri.port)

          if uri.port == 443
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end

          http
        end
      end

      def logger
        Rails.logger
      end

      def tag_logger(*tags)
        tags.unshift("JsonRequest")

        logger.tagged(*tags) { yield }
      end

      # Thanks
      # https://github.com/rest-client/rest-client/blob/master/lib/restclient/request.rb#L600
      def parse_body!
        return unless http_response.present?

        body = http_response.body

        content_encoding = http_response["content-encoding"]

        @body = if (!body) || body.empty?
          body
        elsif content_encoding == "gzip"
          Zlib::GzipReader.new(StringIO.new(body)).read
        elsif content_encoding == "deflate"
          begin
            Zlib::Inflate.new.inflate(body)
          rescue Zlib::DataError
            Zlib::Inflate.new(-Zlib::MAX_WBITS).inflate(body)
          end
        else
          body
        end
      end

      def perform
        return @http_response if @http_response

        @http_response = http.request(http_request)
        parse_body!
        http_response
      end

      def prepare_request
        case method
        when :get
          uri.query = URI.encode_www_form(params)
          @http_request = Net::HTTP::Get.new(uri)
        when :post
          @http_request = Net::HTTP::Post.new(uri)
          set_request_body!
        when :delete
          @http_request = Net::HTTP::Delete.new(uri)
          set_request_body!
        when :patch
          @http_request = Net::HTTP::Patch.new(uri)
          set_request_body!
        when :put
          @http_request = Net::HTTP::Put.new(uri)
          set_request_body!
        end

        return nil unless http_request

        headers.each do |key, value|
          http_request[key] = value
        end
      end

      def set_request_body!
        return unless params.present?

        if use_json_body?
          http_request.body = params.to_json
          http_request["Content-Type"] = "application/json"
        else
          http_request.set_form_data(params.stringify_keys)
        end
      end

      def use_json_body?
        mode == :json
      end

  end
end
