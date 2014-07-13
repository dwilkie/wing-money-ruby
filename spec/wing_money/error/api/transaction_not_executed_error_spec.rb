require 'spec_helper'

describe WingMoney::Error::Api::TransactionNotExecutedError do
  it_should_behave_like "an api error"

  describe "#message" do
    it "should have a default" do
      subject.message.should == "WingMoney did not execute your transaction. Please try again later"
    end
  end
end
