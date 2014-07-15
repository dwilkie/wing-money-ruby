# WingMoney

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'wing_money'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wing_money

## Usage

### Online Payment

You can use *Online Payment* to charge a Wing Account using the Wing account number and *PIN*. This API therefore does not reqire a security code to be generated. You will also need a biller code to use this API.

#### Failed Requests

```ruby
require 'wing_money'

transaction = WingMoney::Transaction::OnlinePayment.new(
  :wing_account_number => "123456",        # account number from which to charge from
  :wing_account_pin    => "1234",          # 4 digit wing pin of account number.
  :description         => "some product",  # description of transaction (optional)
  :biller_code         => "4321",          # Biller Code (issued by Wing)
  :user_id             => "wing-api-user", # Wing API User ID (issued by Wing),
  :password            => "wing-api-pin",  # Wing API Password (issued by Wing)
)

# => #<WingMoney::Transaction::OnlinePayment:0x007fa798eb1350 @params={"wing_account_number"=>"123456", "wing_account_pin"=>"1234", "description"=>"some product", "biller_code"=>"4321", "user_id"=>"wing-api-user", "password"=>"wing-api-pin"}, @api_key=nil>

begin
  response = transaction.execute!
rescue WingMoney::Error::Api::BaseError => error
  error_code = error.code
  error_hash = error.to_hash
  error_json = error.to_json
  error_message = error.message
end

error_code
# => 422
error_hash
# => {"errors"=>{"amount"=>["must be greater than 0"]}, "code"=>422}
error_json
# => "{\"errors\":{\"amount\":[\"must be greater than 0\"]},\"code\":422}"
error_message
# => "422. amount must be greater than 0"

transaction.amount = 1000
# => 1000

begin
  response = transaction.execute!
rescue WingMoney::Error::Api::BaseError => error
  error_code = error.code
  error_hash = error.to_hash
  error_json = error.to_json
  error_message = error.message
end

error_code
# => 500
error_hash
# => {"errors"=>{"base"=>["An API error has occured. We have been notified and are looking into it."]}, "code"=>500}
error_json
# => "{\"errors\":{\"base\":[\"An API error has occured. We have been notified and are looking into it.\"]},\"code\":500}"
error_message
# => "500. An API error has occured. We have been notified and are looking into it."
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/wing_money/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
