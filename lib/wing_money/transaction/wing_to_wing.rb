require_relative "./base"

module WingMoney
  module Transaction
    class WingToWing < ::WingMoney::Transaction::Base

      def wing_destination_account_number=(value)
        params[:wing_destination_account_number] = value
      end

      def wing_destination_usd_account_number=(value)
        params[:wing_destination_usd_account_number] = value
      end

      def wing_destination_khr_account_number=(value)
        params[:wing_destination_khr_account_number] = value
      end

      def khr_usd_buy_rate=(value)
        params[:khr_usd_buy_rate] = value
      end

      def khr_usd_sell_rate=(value)
        params[:khr_usd_sell_rate] = value
      end

      private

      def param_key
        super(:wing_to_wing)
      end

      def resource_endpoint
        super(:wing_to_wings)
      end

      def request_params
        super.merge(
          :wing_destination_account_number => nil,
          :wing_destination_usd_account_number => nil,
          :wing_destination_khr_account_number => nil,
          :khr_usd_buy_rate => nil,
          :khr_usd_sell_rate => nil,
        )
      end
    end
  end
end
