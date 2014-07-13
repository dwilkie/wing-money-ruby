require "vcr"

module WingMoney
  module SpecHelpers
    class RequestHelpers
      def expect_transaction_request!(request_type, response_type, options = {}, &block)
        VCR.use_cassette(
          :"wing_money/api/v1/wing_transaction/#{request_type}/#{response_type}",
          :erb => {:endpoint => transaction_endpoint(request_type)}.merge(options[:erb] || {})
        ) { yield }
      end

      def last_request_body
        WebMock::Util::QueryMapper.query_to_values(WebMock.requests.last.body)
      end

      private

      def transaction_endpoint(request_type)
        api_endpoint = ENV["WING_MONEY_API_ENDPOINT"] || "https://wing.bongloy.com/api/v1"
        "#{api_endpoint}/wing_transaction/#{request_type}"
      end
    end
  end
end
