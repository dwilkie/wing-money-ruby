require 'spec_helper'

describe WingMoney::Error::Api::InvalidRequestError do
  let(:factory_name) { :invalid_request_error }

  it_should_behave_like "an api error"

  describe "#message" do
    subject { build(factory_name) }

    it "should have a default" do
      subject.message.should =~ /Bad Request./
    end
  end
end
