require 'spec_helper'

describe WingMoney::Transaction::WeiLuy do
  let(:factory_name) { :wei_luy_transaction }
  let(:sample_transaction_request_params) { api_helpers.wei_luy_transaction_params }
  let(:transaction_request_type) { :wei_luys }

  it_should_behave_like "a wing money transaction"

  describe "#recipient_mobile" do
    it "should be a public accessor" do
      subject.recipient_mobile = "85512239126"
      subject.recipient_mobile.should == "85512239126"
      subject.params[:recipient_mobile].should == "85512239126"
    end
  end
end
