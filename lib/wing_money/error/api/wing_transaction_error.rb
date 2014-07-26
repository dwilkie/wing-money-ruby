require_relative "transaction_error"

module WingMoney
  module Error
    module Api
      class WingTransactionError < ::WingMoney::Error::Api::TransactionError
        attr_accessor :wing_error_message

        def initialize(code, transaction_id, wing_error_message, options = {})
          self.wing_error_message = wing_error_message
          super(code, transaction_id, options)
        end

        private

        def default_message_string
          wing_error_message
        end
      end
    end
  end
end
