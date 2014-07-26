require 'spec_helper'

describe WingMoney::Error::Api::WingTransactionError  do
  let(:factory_name) { :wing_transaction_error }
  subject { build(factory_name) }

  it_should_behave_like "an api error"
  it_should_behave_like "an api transaction error"

  describe "#message" do
    it "should have a default message" do
      subject.message.should =~ /#{subject.wing_error_message}/
    end
  end
end
