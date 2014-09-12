module WingMoney
  module SpecHelpers
    class RequestHelpers
      def expect_transaction_request!(request_type, response_type, options = {}, &block)

        VCR.use_cassette(
          cassette(request_type, response_type),
          :erb => {:endpoint => transaction_endpoint(request_type)}.merge(options[:erb] || {})
        ) { yield }
      end

      def last_request_body
        last_request && WebMock::Util::QueryMapper.query_to_values(last_request.body)
      end

      def last_request_headers
        last_request && last_request.headers
      end

      def last_request
        WebMock.requests.last
      end

      def asserted_authentication_headers(key)
        {'Authorization' => bearer_authentication(key)}
      end

      private

      def response_types
        @response_types ||= {
          :online_payments => {
            :successful => :"201_created_successful",
            :failed => :"201_created_wing_error_account_blocked"
          },
          :wing_to_wings => {
            :successful => :"201_created_successful",
            :failed => :"201_created_wing_error_account_blocked"
          }
        }
      end

      def cassette(request_type, response_type)
        response_type = ((response_types[request_type] || {})[response_type]) || response_type
        :"wing_money/api/v1/wing_transaction/#{request_type}/#{response_type}"
      end

      def bearer_authentication(key)
        "Bearer #{key}"
      end

      def transaction_endpoint(request_type)
        api_endpoint = ENV["WING_API_ENDPOINT"] || "https://wing-money.bongloy.com/api/v1"
        "#{api_endpoint}/wing_transaction/#{request_type}"
      end
    end
  end
end
