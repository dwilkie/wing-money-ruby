require 'spec_helper'

describe WingMoney::Transaction::OnlinePayment do
  let(:api_helpers) { WingMoney::SpecHelpers::ApiHelpers.new }
  let(:factory_name) { :wing_online_payment_transaction }
  let(:sample_transaction_request_params) { api_helpers.online_payment_transaction_params }
  let(:transaction_request_param)  { sample_transaction_request_params.keys.first }
  let(:valid_factory_params) { sample_transaction_request_params[transaction_request_param] }
  let(:transaction_request_type) { :online_payments }

  it_should_behave_like "a wing money transaction"
end
