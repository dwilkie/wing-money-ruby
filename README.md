# WingMoney

An API Client for Wing Cambodia

## Installation

Add this line to your application's Gemfile:

    gem 'wing_money'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wing_money

## Usage

### Request Parameters and CURL examples.

See [this gist](https://gist.github.com/dwilkie/5aa1a63576ea5454821d)

### Wing2Wing

You can use this API to transfer money from one Wing account to another.

#### Ruby Examples

The following examples actually work so feel free to try them out.

##### Successful Request

```ruby
require 'wing_money'

transaction = WingMoney::Transaction::WingToWing.new(
  :api_key                             => "test_a75d8f5cda47be2c0e164ff96022cb71b6f8dd379ff629eb7ea22c06bd1d1e0a", # Required. Your API Key (issued by Bongloy)
  :amount                              =>  1000,              # Required. The amount you wish to transfer. For usd this amount is in cents. For khr it's in Riel.
  :currency                            => "usd",              # Required. The currency of the transfer. Must be 'usd' or 'khr'.
  :wing_account_number                 => "383661",           # Required. The Wing account number of the sender. One of wing_account_number OR wing_card_number is required.
  :wing_card_number                    => "5018180000383661", # Required. The Wing card number of the sender. One of wing_card_number OR wing_account_number is required.
  :wing_account_pin                    => "2008",             # Required. The 4 digit Wing account PIN of the sender.
  :wing_destination_account_number     => "1615",             # Required. The Wing account number of the receiver.
  :khr_usd_buy_rate                    => 41,                 # Required. How much khr you will buy for 1 usd cent. E.g. if you request to transfer amount: '1000' in currency: 'usd' ($10) from a khr account and you set the khr_usd_buy_rate: '41' the receiver will receive 41000 in khr (41,000KHR). Note this rate will only apply if the requested currency is usd but the sender's account is khr.
  :khr_usd_sell_rate                   => 40,                 # Required. How much khr you will sell for 1 usd cent. E.g. if you request to transfer amount: '40000' in currency: 'khr' (40,000KHR) from a usd account and you set te khr_usd_sell_rate: '40' the receiver will receive 1000 in usd ($10). Note this rate will only apply if the requested currency is khr but the sender's account is usd.
  :wing_destination_usd_account_number => "1614",             # Optional. An alternate account to receive usd transactions. E.g. If the sender's account is usd but the destination account is khr and wing_destination_usd_account_number is set, wing_destination_usd_account will override wing_destination_account_number and the funds will be transfered to wing_destination_usd_account_number instead. Use to avoid Wing currency exchange fees.
  :wing_destination_khr_account_number => "1615",             # Optional. An alternate account to receive khr transactions. E.g. If the sender's account is khr but the destination account is usd and wing_destination_khr_account_number is set, wing_destination_khr_account will override wing_destination_account_number and the funds will be transfered to wing_destination_khr_account_number instead. Use to avoid Wing currency exchange fees.
)
# => #<WingMoney::Transaction::WingToWing:0x007fac397e4338 @params={"amount"=>1000, "currency"=>"usd", "wing_account_number"=>"383661", "wing_card_number"=>"5018180000383661", "wing_account_pin"=>"2008", "wing_destination_account_number"=>"1615", "khr_usd_buy_rate"=>41, "khr_usd_sell_rate"=>40, "wing_destination_usd_account_number"=>"1614", "wing_destination_khr_account_number"=>"1615"}, @api_key="test_a75d8f5cda47be2c0e164ff96022cb71b6f8dd379ff629eb7ea22c06bd1d1e0a">

begin
  transaction.execute!
rescue WingMoney::Error::Api::BaseError => error
  error_code = error.code
  error_hash = error.to_hash
  error_json = error.to_json
  error_message = error.message
end
# => true

transaction.successful?
# => true

transaction.id
# => 66     # unique id of transaction

transaction.livemode
# => false  # whether or not the transaction was live

transaction.created_at
# => "2014-09-12T06:04:40.495Z"

wing_response = transaction.wing_response
# => {"successful"=>true, "result"=>"SUCCESS", "error_code"=>nil, "error_message"=>"SUCCESS", "amount_khr"=>0, "amount_usd"=>1000, "balance"=>{"amount"=>10521588, "currency"=>"usd"}, "total"=>{"amount"=>1025, "currency"=>"usd"}, "fee"=>{"amount"=>25, "currency"=>"usd"}, "transaction_id"=>"EAA748178", "tid"=>"EAA748178", "recipient_account_name"=>"WCX USD", "recipient_account_number"=>"1614"}

wing_response["result"]
# => "SUCCESS"

wing_response["amount_khr"]
# => 0

wing_response["amount_usd"]
# => 1000

wing_response["recipient_account_name"]
# => "WCX USD"

wing_response["recipient_account_number"]
# => "1614"

wing_response["balance"]
# => {"amount"=>10521588, "currency"=>"usd"}

wing_response["total"]
# => {"amount"=>1025, "currency"=>"usd"}

wing_response["fee"]
# => {"amount"=>25, "currency"=>"usd"}

wing_response["tid"]
# => "EAA748178"
```

##### Failed Requests

```ruby
require 'wing_money'

transaction = WingMoney::Transaction::WingToWing.new(
  :api_key                             => "test_a75d8f5cda47be2c0e164ff96022cb71b6f8dd379ff629eb7ea22c06bd1d1e0a",
  :amount                              =>  nil,
  :currency                            => "usd",
  :wing_account_number                 => "383661",
  :wing_card_number                    => "5018180000383661",
  :wing_account_pin                    => "2008",
  :wing_destination_account_number     => "1615",
  :khr_usd_buy_rate                    => 41,
  :khr_usd_sell_rate                   => 40,
  :wing_destination_usd_account_number => "1614",
  :wing_destination_khr_account_number => "1615"
)
# => #<WingMoney::Transaction::WingToWing:0x007fac3a3b1828 @params={"amount"=>nil, "currency"=>"usd", "wing_account_number"=>"383661", "wing_card_number"=>"5018180000383661", "wing_account_pin"=>"2008", "wing_destination_account_number"=>"1615", "khr_usd_buy_rate"=>41, "khr_usd_sell_rate"=>40, "wing_destination_usd_account_number"=>"1614", "wing_destination_khr_account_number"=>"1615"}, @api_key="test_a75d8f5cda47be2c0e164ff96022cb71b6f8dd379ff629eb7ea22c06bd1d1e0a">

begin
  transaction.execute!
rescue WingMoney::Error::Api::BaseError => error
  error_code = error.code
  error_hash = error.to_hash
  error_json = error.to_json
  error_message = error.message
end
# => "422. amount can't be blank, amount is not a number"

error_code
# => 422

error_hash
# => {"errors"=>{"amount"=>["can't be blank", "is not a number"]}, "code"=>422}

error_json
# => "{\"errors\":{\"amount\":[\"can't be blank\",\"is not a number\"]},\"code\":422}"

error_message
# => "422. amount can't be blank, amount is not a number"
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/wing_money/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
