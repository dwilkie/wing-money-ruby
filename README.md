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

### Online Payment

You can use *Online Payment* to charge a Wing Account using the Wing account number and *PIN*. You will also need a biller code to use this API.

#### Successful Requests

```ruby
require 'wing_money'

transaction = WingMoney::Transaction::OnlinePayment.new(
  :api_key             => "test_a75d8f5cda47be2c0e164ff96022cb71b6f8dd379ff629eb7ea22c06bd1d1e0a", # Required. Your API Key (issued by Bongloy)
  :amount              =>  1000,           # Required. Amount in cents of which to charge (e.g. $10 = 1000)
  :wing_account_number => "383661",        # Required. Account number from which to charge from
  :wing_account_pin    => "2008",          # Required. 4 digit wing pin of account number
  :biller_code         => "2027",          # Required. Biller Code (issued by Wing)
  :user_id             => "wing-api-user", # Optional. Wing API User ID (issued by Wing)
  :password            => "wing-api-pin",  # Optional. Wing API Password (issued by Wing)
  :description         => "some product",  # Optional. description of transaction (optional)
)

# => #<WingMoney::Transaction::OnlinePayment:0x007fa798eb1350 @params={"amount"=>1000, "wing_account_number"=>"383661", "wing_account_pin"=>"2008", "description"=>"some product", "biller_code"=>"2027", "user_id"=>"wing-api-user", "password"=>"wing-api-pin"}, @api_key="test_a75d8f5cda47be2c0e164ff96022cb71b6f8dd379ff629eb7ea22c06bd1d1e0a">

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

wing_response = transaction.wing_response
# = {"successful"=>true, "raw"=>{"online_payment_req_response"=>{"return"=>"<StandardResponse><ErrorCode>200</ErrorCode><DetailResponse>Success Bill Pay\nTo Mehk .\nCustomer Name:Cust USD\nAmt: 10.00USD\nTotal: 10.00USD\nBal : 106,588.90USD\nTID : ONL000972</DetailResponse><TransactionID>ONL000972</TransactionID></StandardResponse>", "@xmlns:ns"=>"http://external.ws.wingmoney.com"}}, "result"=>"Success Bill Pay", "error_code"=>"200", "error_message"=>"Success Bill Pay", "amount_khr"=>0, "amount_usd"=>1000, "balance"=>{"amount"=>10658890, "currency"=>"usd"}, "total"=>{"amount"=>1000, "currency"=>"usd"}, "fee"=>{"amount"=>nil, "currency"=>nil}, "transaction_id"=>"ONL000972", "tid"=>"ONL000972", "recipient_account_name"=>"Mehk .", "customer_account_name"=>"Cust USD"}

wing_response["result"]
# => "Success Bill Pay"

wing_response["amount_khr"]
# => 0

wing_response["amount_usd"]
# => 1000

wing_response["recipient_account_name"]
# => "Mehk ."

wing_response["customer_account_name"]
# => "Cust USD"

wing_response["balance"]
# => {"amount"=>10658890, "currency"=>"usd"}

wing_response["total"]
# => {"amount"=>1000, "currency"=>"usd"}

wing_response["fee"]
# => {"amount"=>nil, "currency"=>nil}

wing_response["tid"]
# => "ONL000972"
```

#### Failed Requests

```ruby
require 'wing_money'

transaction = WingMoney::Transaction::OnlinePayment.new(
  :api_key             => "test_a75d8f5cda47be2c0e164ff96022cb71b6f8dd379ff629eb7ea22c06bd1d1e0a", # Required. Your API Key (issued by Bongloy)
  :amount              =>  nil,            # Required. Amount in cents of which to charge (e.g. $10 = 1000)
  :wing_account_number => "383661",        # Required. Account number from which to charge from
  :wing_account_pin    => "2008",          # Required. 4 digit wing pin of account number
  :biller_code         => "2027",          # Required. Biller Code (issued by Wing)
  :user_id             => "wing-api-user", # Optional. Wing API User ID (issued by Wing)
  :password            => "wing-api-pin",  # Optional. Wing API Password (issued by Wing)
  :description         => "some product",  # Optional. description of transaction (optional)
)

# => #<WingMoney::Transaction::OnlinePayment:0x007fa798eb1350 @params={"amount=>nil, "wing_account_number"=>"383661", "wing_account_pin"=>"2008", "description"=>"some product", "biller_code"=>"2027", "user_id"=>"wing-api-user", "password"=>"wing-api-pin"}, @api_key="test_a75d8f5cda47be2c0e164ff96022cb71b6f8dd379ff629eb7ea22c06bd1d1e0a">

begin
  transaction.execute!
rescue WingMoney::Error::Api::BaseError => error
  error_code = error.code
  error_hash = error.to_hash
  error_json = error.to_json
  error_message = error.message
end

# => "422. amount must be greater than 0"

error_code
# => 422
error_hash
# => {"errors"=>{"amount"=>["must be greater than 0"]}, "code"=>422}
error_json
# => "{\"errors\":{\"amount\":[\"must be greater than 0\"]},\"code\":422}"
error_message
# => "422. amount must be greater than 0"
```

### Wing To Wing

You can use this API to transfer money from one Wing account to another.

#### Successful Requests

```ruby
require 'wing_money'

transaction = WingMoney::Transaction::WingToWing.new(
  :api_key                         => "test_a75d8f5cda47be2c0e164ff96022cb71b6f8dd379ff629eb7ea22c06bd1d1e0a", # Required. Your API Key (issued by Bongloy)
  :amount                          =>  1000,           # Required. Amount in cents to transfer (e.g. $10 = 1000)
  :wing_account_number             => "383661",        # Required. Account number from which send the funds from
  :wing_account_pin                => "2008",          # Required. 4 digit wing pin of account number
  :wing_destination_account_number => "1615",          # Required. Account number in which to send the funds to
  :user_id                         => "wing-api-user", # Optional. Wing API User ID (issued by Wing)
  :password                        => "wing-api-pin",  # Optional. Wing API Password (issued by Wing)
)

# => #<WingMoney::Transaction::WingToWing:0x007f4ce2534158 @params={"amount"=>1000, "wing_account_number"=>"383661", "wing_account_pin"=>"2008", "wing_destination_account_number"=>"1615"}, @api_key="test_a75d8f5cda47be2c0e164ff96022cb71b6f8dd379ff629eb7ea22c06bd1d1e0a">

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

wing_response = transaction.wing_response
# = {"successful"=>true, "raw"=>{"req_wing2_wing_response"=>{"return"=>"<StandardResponse><ErrorCode>200</ErrorCode><DetailResponse>Success W2W\nTo WCX KHR\nWING # 00001615\nAmt: 10.00USD=40,100KHR\nFee: 0.25USD\nTotal: 10.25USD\nBal: 106,578.65USD\nTID : EAA747564</DetailResponse><TransactionID>EAA747564</TransactionID></StandardResponse>", "@xmlns:ns"=>"http://external.ws.wingmoney.com"}}, "result"=>"Success W2W", "error_code"=>"200", "error_message"=>"Success W2W", "amount_khr"=>40100, "amount_usd"=>1000, "balance"=>{"amount"=>10657865, "currency"=>"usd"}, "total"=>{"amount"=>1025, "currency"=>"usd"}, "fee"=>{"amount"=>25, "currency"=>"usd"}, "transaction_id"=>"EAA747564", "tid"=>"EAA747564", "recipient_account_name"=>"WCX KHR", "recipient_account_number"=>"1615"}

wing_response["result"]
# => "Success W2W"

wing_response["amount_khr"]
# => 40100

wing_response["amount_usd"]
# => 1000

wing_response["recipient_account_name"]
# => "WCX KHR"

wing_response["recipient_account_number"]
# => "1615"

wing_response["balance"]
# => {"amount"=>10657865, "currency"=>"usd"}

wing_response["total"]
# => {"amount"=>1025, "currency"=>"usd"}

wing_response["fee"]
# => {"amount"=>25, "currency"=>"usd"}

wing_response["tid"]
# => "EAA747564"
```

#### Failed Requests

```ruby
require 'wing_money'

transaction = WingMoney::Transaction::WingToWing.new(
  :api_key                         => "test_a75d8f5cda47be2c0e164ff96022cb71b6f8dd379ff629eb7ea22c06bd1d1e0a", # Required. Your API Key (issued by Bongloy)
  :amount                          =>  nil,            # Required. Amount in cents to transfer (e.g. $10 = 1000)
  :wing_account_number             => "383661",        # Required. Account number from which send the funds from
  :wing_account_pin                => "2008",          # Required. 4 digit wing pin of account number
  :wing_destination_account_number => "1615",          # Required. Account number in which to send the funds to
  :user_id                         => "wing-api-user", # Optional. Wing API User ID (issued by Wing)
  :password                        => "wing-api-pin",  # Optional. Wing API Password (issued by Wing)
)

# => #<WingMoney::Transaction::WingToWing:0x007f4ce2028268 @params={"amount"=>nil, "wing_account_number"=>"383661", "wing_account_pin"=>"2008", "wing_destination_account_number"=>"1615"}, @api_key="test_a75d8f5cda47be2c0e164ff96022cb71b6f8dd379ff629eb7ea22c06bd1d1e0a">

begin
  transaction.execute!
rescue WingMoney::Error::Api::BaseError => error
  error_code = error.code
  error_hash = error.to_hash
  error_json = error.to_json
  error_message = error.message
end

# => "422. amount must be greater than 0"

error_code
# => 422
error_hash
# => {"errors"=>{"amount"=>["must be greater than 0"]}, "code"=>422}
error_json
# => "{\"errors\":{\"amount\":[\"must be greater than 0\"]},\"code\":422}"
error_message
# => "422. amount must be greater than 0"
```

### Wei Luy

You can use this API to transfer money from one Wing account anybody using the sender's PIN and the recipient's mobile number.

#### Successful Requests

```ruby
require 'wing_money'

transaction = WingMoney::Transaction::WeiLuy.new(
  :api_key                         => "test_a75d8f5cda47be2c0e164ff96022cb71b6f8dd379ff629eb7ea22c06bd1d1e0a", # Required. Your API Key (issued by Bongloy)
  :amount                          =>  1000,           # Required. Amount in cents to transfer (e.g. $10 = 1000)
  :wing_account_number             => "383661",        # Required. Account number from which send the funds from
  :wing_account_pin                => "2008",          # Required. 4 digit wing pin of account number
  :recipient_mobile                => "85512239137",   # Required. Mobile Number of Recipient
  :user_id                         => "wing-api-user", # Optional. Wing API User ID (issued by Wing)
  :password                        => "wing-api-pin",  # Optional. Wing API Password (issued by Wing)
)

# => #<WingMoney::Transaction::WeiLuy:0x007f4ce1a92fb0 @params={"amount"=>1000, "wing_account_number"=>"383661", "wing_account_pin"=>"2008", "recipient_mobile"=>"85512239137"}, @api_key="test_a75d8f5cda47be2c0e164ff96022cb71b6f8dd379ff629eb7ea22c06bd1d1e0a">

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

wing_response = transaction.wing_response
# => {"successful"=>true, "raw"=>{"req_wing_wei_luy_response"=>{"return"=>"<StandardResponse><ErrorCode>200</ErrorCode><DetailResponse>Success WWL\ncode: 26235470\nRCPT#: 012239137 \nAmt: 10.00USD\nFee: 1.50USD\nTotal: 11.50USD \nBal: 106,567.15USD\nTID: AAD720591</DetailResponse><TransactionID>AAD720591</TransactionID></StandardResponse>", "@xmlns:ns"=>"http://external.ws.wingmoney.com"}}, "result"=>"Success WWL", "error_code"=>"200", "error_message"=>"Success WWL", "amount_khr"=>0, "amount_usd"=>1000, "balance"=>{"amount"=>10656715, "currency"=>"usd"}, "total"=>{"amount"=>1150, "currency"=>"usd"}, "fee"=>{"amount"=>150, "currency"=>"usd"}, "transaction_id"=>"AAD720591", "tid"=>"AAD720591", "recipient_mobile"=>"85512239137", "recipient_code"=>"26235470"}

wing_response["result"]
# => "Success WWL"

wing_response["amount_khr"]
# => 0

wing_response["amount_usd"]
# => 1000

wing_response["recipient_mobile"]
# => "85512239137"

wing_response["recipient_code"] # give this to the recipient to redeem the transfer
# => "26235470"

wing_response["balance"]
# => {"amount"=>10656715, "currency"=>"usd"}

wing_response["total"]
# => {"amount"=>1150, "currency"=>"usd"}

wing_response["fee"]
# => {"amount"=>150, "currency"=>"usd"}

wing_response["tid"]
# => "AAD720591"
```
#### Failed Requests

```ruby
require 'wing_money'

transaction = WingMoney::Transaction::WingToWing.new(
  :api_key                         => "test_a75d8f5cda47be2c0e164ff96022cb71b6f8dd379ff629eb7ea22c06bd1d1e0a", # Required. Your API Key (issued by Bongloy)
  :amount                          =>  nil,            # Required. Amount in cents to transfer (e.g. $10 = 1000)
  :wing_account_number             => "9999",          # Required. Account number from which send the funds from
  :wing_account_pin                => "2008",          # Required. 4 digit wing pin of account number
  :wing_destination_account_number => "1615",          # Required. Account number in which to send the funds to
  :user_id                         => "wing-api-user", # Optional. Wing API User ID (issued by Wing)
  :password                        => "wing-api-pin",  # Optional. Wing API Password (issued by Wing)
)

# => #<WingMoney::Transaction::WeiLuy:0x007f4ce294d898 @params={"amount"=>1000, "wing_account_number"=>"9999", "wing_account_pin"=>"2008", "recipient_mobile"=>"85512239137"}, @api_key="test_a75d8f5cda47be2c0e164ff96022cb71b6f8dd379ff629eb7ea22c06bd1d1e0a">

begin
  transaction.execute!
rescue WingMoney::Error::Api::BaseError => error
  error_code = error.code
  error_hash = error.to_hash
  error_json = error.to_json
  error_message = error.message
end

# => "000040. Oops!\nRequeted amount should be greater than fees."

error_code
# => "000040"
error_hash
# => {"errors"=>{"base"=>["Oops!\nRequeted amount should be greater than fees."]}, "code"=>"000040", "transaction_id"=>23}
error_json
# => "{\"errors\":{\"base\":[\"Oops!\\nRequeted amount should be greater than fees.\"]},\"code\":\"000040\",\"transaction_id\":23}"
error_message
# => "000040. Oops!\nRequeted amount should be greater than fees."
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/wing_money/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
