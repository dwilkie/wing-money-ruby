require_relative "./base"

module WingMoney
  module Transaction
    class WingToWing < ::WingMoney::Transaction::Base

      def wing_destination_account_number=(value)
        params[:wing_destination_account_number] = value
      end

      private

      def param_key
        super(:wing_to_wing)
      end

      def resource_endpoint
        super(:wing_to_wings)
      end

      def request_params
        super.merge(:wing_destination_account_number => nil)
      end
    end
  end
end
