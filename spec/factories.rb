FactoryGirl.define do
  factory :error, :class => WingMoney::Error::Api::BaseError do
    skip_create

    code "401"

    initialize_with { new(code) }
    factory :invalid_request_error,          :class => WingMoney::Error::Api::InvalidRequestError
    factory :authentication_error,           :class => WingMoney::Error::Api::AuthenticationError

    factory :transaction_not_executed_error, :class => WingMoney::Error::Api::TransactionNotExecutedError do
      transaction_id 1
      initialize_with { new(code, transaction_id) }
    end

    factory :wing_transaction_error, :class => WingMoney::Error::Api::WingTransactionError do
      transaction_id 1
      wing_error_message "Account of wing-api-user-id was blocked!!!"
      initialize_with { new(code, transaction_id, wing_error_message) }
    end
  end

  factory :wing_transaction, :class => WingMoney::Transaction::Base do
    skip_create
    with_card_number

    ignore do
      params({})
    end

    trait :with_card_number do
      wing_card_number { params[:wing_card_number] }
    end

    trait :with_account_number do
      wing_account_number { params[:wing_account_number] }
    end

    amount { params[:amount] }
    currency { params[:currency] }
    wing_account_pin { params[:wing_account_pin] }
    user_id { params[:user_id] }
    password { params[:password] }

    factory :wei_luy_transaction, :class => WingMoney::Transaction::WeiLuy do
      recipient_mobile { params[:recipient_mobile] }
    end

    factory :wing_to_wing_transaction, :class => WingMoney::Transaction::WingToWing do
      wing_destination_account_number { params[:wing_destination_account_number] }
      wing_destination_usd_account_number { params[:wing_destination_usd_account_number] }
      wing_destination_khr_account_number { params[:wing_destination_khr_account_number] }
      khr_usd_buy_rate { params[:khr_usd_buy_rate] }
      khr_usd_sell_rate { params[:khr_usd_sell_rate] }
    end
  end
end
