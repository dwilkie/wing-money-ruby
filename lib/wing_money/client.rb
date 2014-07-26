module WingMoney
  class Client
    require 'httparty'

    WING_API_ENDPOINT = "https://wing-money.bongloy.com/api/v1"

    attr_accessor :api_endpoint

    def initialize(options = {})
      self.api_endpoint = options[:api_endpoint] || ENV["WING_API_ENDPOINT"] || WING_API_ENDPOINT
    end

    def execute_transaction!(path, api_key, payload = {}, headers = {})
      handle_response(
        HTTParty.post(
          resource_endpoint(path),
          :body => payload, :headers => authentication_headers(api_key).merge(headers), :verify => false
        )
      )
    end

    private

    def handle_response(response)
      unless response.success?
        if response.code == 401
          raise(
            ::WingMoney::Error::Api::AuthenticationError.new(response.code)
          )
        elsif response.code == 422
          raise(
            ::WingMoney::Error::Api::InvalidRequestError.new(
              response.code, :errors => response.body
            )
          )
        else
          raise(
            ::WingMoney::Error::Api::BaseError.new(response.code)
          )
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
