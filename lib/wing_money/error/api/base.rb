module WingMoney
  module Error
    module Api
      class Base < ::StandardError
        attr_accessor :message

        def initialize(options = {})
          self.message = options[:message]
        end

        def message
          @message || "An API error has occured. We have been notified and are looking into it."
        end
      end
    end
  end
end
