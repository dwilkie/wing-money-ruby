require_relative "transaction_error"

module WingMoney
  module Error
    module Api
      class TransactionNotExecutedError < ::WingMoney::Error::Api::TransactionError

        private

        def default_message_string
          "The transaction was created but not executed on Wing."
        end
      end
    end
  end
end
