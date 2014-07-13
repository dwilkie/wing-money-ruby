module WingMoney
  class Client
    require 'httparty'

    WING_API_ENDPOINT = "https://wing.bongloy.com/api/v1"

    attr_accessor :api_endpoint

    def initialize(options = {})
      self.api_endpoint = options[:api_endpoint] || ENV["WING_API_ENDPOINT"] || WING_API_ENDPOINT
    end

    def execute_transaction!(path, api_key, payload = {}, headers = {})
      handle_response(
        HTTParty.post(
          resource_endpoint(path),
          :body => payload, :headers => authentication_headers(api_key).merge(headers)
        )
      )
    end

    private

    def handle_response(response)
      unless response.success?
        if response.code == 401
          raise(::WingMoney::Error::Api::AuthenticationError)
        elsif response.code == 422 || response.code == 400
          raise(::WingMoney::Error::Api::InvalidRequestError.new(:message => response.body))
        elsif response.code == 404
          raise(::WingMoney::Error::Api::NotFoundError.new(:resource => response.request.path.to_s))
        else
          raise(::WingMoney::Error::Api::Base)
        end
      end
      response.body ? JSON.parse(response.body) : {}
    end

    def authentication_headers(api_key)
      {"Authorization" => "Bearer #{api_key}"}
    end

    def resource_endpoint(path)
      "#{api_endpoint}/#{path}"
    end
  end
end
