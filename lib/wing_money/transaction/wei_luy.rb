require_relative "./base"

module WingMoney
  module Transaction
    class WeiLuy < ::WingMoney::Transaction::Base

      def recipient_mobile=(value)
        params[:recipient_mobile] = value
      end

      private

      def param_key
        super(:wei_luy)
      end

      def resource_endpoint
        super(:wei_luys)
      end

      def request_params
        super.merge(:recipient_mobile => nil)
      end
    end
  end
end
