require_relative "./base"

module WingMoney
  module Transaction
    class OnlinePayment < ::WingMoney::Transaction::Base

      def biller_code=(value)
        params[:biller_code] = value
      end

      private

      def param_key
        super(:online_payment)
      end

      def resource_endpoint
        super(:online_payments)
      end

      def request_params
        super.merge(:biller_code => nil)
      end
    end
  end
end
