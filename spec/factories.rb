FactoryGirl.define do
  factory :wing_transaction, :class => WingMoney::Transaction::Base do
    skip_create

    ignore do
      params({})
    end

    amount { params[:amount] }
    wing_account_number { params[:wing_account_number] }
    wing_account_pin { params[:wing_account_pin] }
    user_id { params[:user_id] }
    password { params[:password] }
    biller_code { params[:biller_code] }

    factory :wing_online_payment_transaction, :class => WingMoney::Transaction::OnlinePayment
  end
end
