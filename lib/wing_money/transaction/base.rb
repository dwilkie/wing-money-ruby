require "hashie"
require "active_support/core_ext/hash"
require_relative "../client"

module WingMoney
  module Transaction
    class Base

      attr_accessor :api_key, :params

      class Attributes < Hash
        include Hashie::Extensions::MethodAccess
        include Hashie::Extensions::IndifferentAccess
      end

      def initialize(options = {})
        self.params = options
        self.api_key = params.delete(:api_key)
      end

      def execute!
        self.params = client.execute_transaction!(resource_endpoint, api_key, payload)
        raise(::WingMoney::Error::Api::TransactionNotExecutedError.new(201, id)) unless executed?
        raise(::WingMoney::Error::Api::WingTransactionError.new(wing_error_code, id, wing_error_message)) unless successful?
        true
      end

      def successful?
        wing_response["successful"]
      end

      def wing_response
        result["wing_response"] || {}
      end

      def wing_error_code
        wing_response["error_code"]
      end

      def wing_error_message
        wing_response["error_message"]
      end

      def params=(options)
        @params = Attributes[options]
      end

      [
        :amount, :wing_account_number, :wing_card_number,
        :wing_account_pin, :user_id, :password
      ].each do |public_accessor|
        mod = Module.new
        include mod
        mod.class_eval <<-RUBY, __FILE__, __LINE__+1
          def #{public_accessor}=(value)
            params[:#{public_accessor}] = value
          end
        RUBY
      end

      private

      def client
        @client ||= ::WingMoney::Client.new
      end

      def param_key(type)
        "wing_transaction_#{type}"
      end

      def payload
        {param_key => params.slice(*request_params.keys)}
      end

      def request_params
        {
          :amount => nil,
          :wing_account_number => nil,
          :wing_card_number => nil,
          :wing_account_pin => nil,
          :user_id => nil,
          :password => nil
        }
      end

      def resource_endpoint(type)
        "wing_transaction/#{type}"
      end

      def method_missing(name, *args)
        params.public_send(name)
      end
    end
  end
end
