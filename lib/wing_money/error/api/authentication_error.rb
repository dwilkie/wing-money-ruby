require_relative "base"

module WingMoney
  module Error
    module Api
      class AuthenticationError < ::WingMoney::Error::Api::Base

        def message
          @message || "No valid API key provided."
        end
      end
    end
  end
end
