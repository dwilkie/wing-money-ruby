require_relative "base"

module WingMoney
  module Error
    module Api
      class TransactionNotExecutedError < ::WingMoney::Error::Api::Base
        def message
          @message || "WingMoney did not execute your transaction. Please try again later"
        end
      end
    end
  end
end
