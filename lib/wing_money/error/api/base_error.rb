module WingMoney
  module Error
    module Api
      class BaseError < ::StandardError
        attr_accessor :code, :errors

        def initialize(code, options = {})
          self.code = code
          self.errors = options[:errors]
        end

        def message
          default_message_with_code
        end

        def to_json
          to_hash.to_json
        end

        def to_hash
          JSON.parse((errors || default_errors)).merge("code" => code)
        end

        private

        def full_error_messages(attribute, messages)
          return messages if attribute == "base"
          messages.map { |message| "#{attribute} #{message}" }
        end

        def default_message
          errors ? JSON.parse(errors)["errors"].map { |attribute, messages| full_error_messages(attribute, messages)}.join(", ") : default_message_string
        end

        def default_message_with_code
          "#{code}. #{default_message}"
        end

        def default_message_string
          "An API error has occured. We have been notified and are looking into it."
        end

        def default_errors
          {"errors" => {"base" => [default_message_string]}}.to_json
        end
      end
    end
  end
end
