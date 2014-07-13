require_relative "./base"

module WingMoney
  module Transaction
    class OnlinePayment < ::WingMoney::Transaction::Base
      private

      def param_key
        super(:online_payment)
      end

      def resource_endpoint
        super(:online_payments)
      end
    end
  end
end
