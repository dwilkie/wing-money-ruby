require 'spec_helper'

describe WingMoney::Transaction::OnlinePayment do
  let(:factory_name) { :online_payment_transaction }
  let(:sample_transaction_request_params) { api_helpers.online_payment_transaction_params }
  let(:transaction_request_type) { :online_payments }

  it_should_behave_like "a wing money transaction"

  describe "#biller_code" do
    it "should be a public accessor" do
      subject.biller_code = "1234"
      subject.biller_code.should == "1234"
      subject.params[:biller_code].should == "1234"
    end
  end
end
