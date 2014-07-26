require 'spec_helper'

describe WingMoney::Transaction::WingToWing do
  let(:factory_name) { :wing_to_wing_transaction }
  let(:sample_transaction_request_params) { api_helpers.wing_to_wing_transaction_params }
  let(:transaction_request_type) { :wing_to_wings }

  it_should_behave_like "a wing money transaction"

  describe "#wing_destination_account_number" do
    it "should be a public accessor" do
      subject.wing_destination_account_number = "712345"
      subject.wing_destination_account_number.should == "712345"
      subject.params[:wing_destination_account_number].should == "712345"
    end
  end
end
