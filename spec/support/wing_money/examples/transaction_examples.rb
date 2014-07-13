module WingMoney
  module SpecHelpers
    module TransactionExamples
      shared_examples_for "a wing money transaction" do
        subject { build(factory_name, :params => valid_factory_params) }
        let(:request_helpers) { WingMoney::SpecHelpers::RequestHelpers.new }

        def request_body
          request_helpers.last_request_body
        end

        def expect_transaction_request!(transaction_response_type, options = {}, &block)
          request_helpers.expect_transaction_request!(transaction_request_type, transaction_response_type, options, &block)
        end

        [
          :amount, :wing_account_number, :wing_account_pin,
          :user_id, :password, :biller_code
        ].each do |public_accessor|
          describe "##{public_accessor}" do
            it "should be a public accessor" do
              subject.public_send(:"#{public_accessor}=", public_accessor)
              subject.public_send(public_accessor).should == public_accessor
              subject.params[public_accessor].should == public_accessor
            end
          end
        end

        describe "#execute!", :focus do
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

            it "should raise an error" do
              expect { do_execute }.to raise_error(
                ::WingMoney::Error::Api::TransactionNotExecutedError
              )
              assert_transaction_request!
            end
          end
        end
      end
    end
  end
end
