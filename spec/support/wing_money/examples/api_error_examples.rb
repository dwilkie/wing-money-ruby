module WingMoney
  module SpecHelpers
    module ApiErrorExamples

      shared_examples_for "an api error" do
        describe "#initialize(options = {})" do
          it "should allow initialization with a message" do
            error = described_class.new(:message => "message")
            error.message.should == "message"
          end
        end

        describe "#message" do
          it "should have a default" do
            subject.message.should_not be_nil
          end
        end
      end
    end
  end
end
