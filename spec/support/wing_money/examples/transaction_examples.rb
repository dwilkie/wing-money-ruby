module WingMoney
  module SpecHelpers
    module TransactionExamples
      shared_examples_for "a wing money transaction" do
        subject { build(factory_name, :params => valid_factory_params) }

        let(:api_helpers) { WingMoney::SpecHelpers::ApiHelpers.new }
        let(:request_helpers) { WingMoney::SpecHelpers::RequestHelpers.new }
        let(:transaction_request_param)  { sample_transaction_request_params.keys.first }
        let(:valid_factory_params) { sample_transaction_request_params[transaction_request_param] }

        def request_body
          request_helpers.last_request_body
        end

        def expect_transaction_request!(transaction_response_type, options = {}, &block)
          request_helpers.expect_transaction_request!(transaction_request_type, transaction_response_type, options, &block)
        end

        [
          :amount, :wing_account_number, :wing_account_pin,
          :user_id, :password
        ].each do |public_accessor|
          describe "##{public_accessor}" do
            it "should be a public accessor" do
              subject.public_send(:"#{public_accessor}=", public_accessor)
              subject.public_send(public_accessor).should == public_accessor
              subject.params[public_accessor].should == public_accessor
            end
          end
        end

        describe "#execute!" do
          let(:asserted_request_params) { subject.params }

          def do_execute
            expect_transaction_request!(transaction_response_type) do
              subject.execute!.should == true
            end
          end

          def assert_transaction_request!
            request_body[transaction_request_param.to_s].should == asserted_request_params
          end

          before do
            asserted_request_params
          end

          context "transaction is not executed" do
            let(:transaction_response_type) { "201_created_not_executed" }

            it "should raise a TransactionNotExecutedError" do
              expect { do_execute }.to raise_error(
                ::WingMoney::Error::Api::TransactionNotExecutedError
              )
              assert_transaction_request!
            end
          end

          context "invalid api key" do
            let(:transaction_response_type) { "401_unauthorized" }

            it "should raise an AuthenticationError" do
              expect { do_execute }.to raise_error(
                ::WingMoney::Error::Api::AuthenticationError
              )
              assert_transaction_request!
            end
          end

          context "wing error (account blocked)" do
            let(:transaction_response_type) { "201_created_wing_error_account_blocked" }

            it "should raise a WingTransactionError" do
              expect { do_execute }.to raise_error(
                ::WingMoney::Error::Api::WingTransactionError
              )
              assert_transaction_request!
            end
          end

          context "transaction executed" do
            let(:transaction_response_type) { "201_created_successful" }

            it "should not raise any errors" do
              do_execute
              subject.successful?.should == true
              assert_transaction_request!
            end
          end
        end
      end
    end
  end
end
