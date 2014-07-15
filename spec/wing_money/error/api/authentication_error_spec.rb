require 'spec_helper'

describe WingMoney::Error::Api::AuthenticationError do
  let(:factory_name) { :authentication_error }
  it_should_behave_like "an api error"

  describe "#message" do
    subject { build(factory_name) }

    it "should have a default message" do
      subject.message.should =~ /No valid API key provided./
    end
  end
end
