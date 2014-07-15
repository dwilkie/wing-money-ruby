require_relative "base_error"

module WingMoney
  module Error
    module Api
      class InvalidRequestError < ::WingMoney::Error::Api::BaseError
        private

        def default_message_string
          "Bad Request."
        end
      end
    end
  end
end
