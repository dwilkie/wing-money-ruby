require 'spec_helper'

describe WingMoney::Error::Api::TransactionNotExecutedError  do
  let(:factory_name) { :transaction_not_executed_error }
  subject { build(factory_name) }

  it_should_behave_like "an api error"
  it_should_behave_like "an api transaction error"

  describe "#message" do
    it "should have a default message" do
      subject.message.should =~ /The transaction was created but not executed on Wing./
    end
  end
end
