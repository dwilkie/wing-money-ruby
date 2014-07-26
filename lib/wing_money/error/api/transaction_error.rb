require_relative "base_error"

module WingMoney
  module Error
    module Api
      class TransactionError < ::WingMoney::Error::Api::BaseError
        attr_accessor :transaction_id

        def initialize(code, transaction_id, options = {})
          self.transaction_id = transaction_id
          super(code, options)
        end

        def to_hash
          super.merge("transaction_id" => transaction_id)
        end
      end
    end
  end
end
