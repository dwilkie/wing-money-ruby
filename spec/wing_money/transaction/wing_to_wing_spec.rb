require 'spec_helper'

describe WingMoney::Transaction::WingToWing do
  include ::WingMoney::SpecHelpers::TransactionExamples

  let(:factory_name) { :wing_to_wing_transaction }
  let(:sample_transaction_request_params) { api_helpers.wing_to_wing_transaction_params }
  let(:transaction_request_type) { :wing_to_wings }

  it_should_behave_like "a wing money transaction"

  [
    :wing_destination_account_number,
    :wing_destination_usd_account_number,
    :wing_destination_khr_account_number,
    :khr_usd_buy_rate,
    :khr_usd_sell_rate,
  ].each do |public_accessor|
    describe "##{public_accessor}" do
      it "should be a public accessor" do
        assert_public_accessor!(public_accessor)
      end
    end
  end
end
