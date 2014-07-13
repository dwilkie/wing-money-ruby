require 'webmock/rspec'

WebMock.disable_net_connect!

# From: https://gist.github.com/2596158
# Thankyou Bartosz Blimke!
# https://twitter.com/bartoszblimke/status/198391214247124993

module WebMock
  module LastRequest
    def clear_requests!
      @requests = nil
    end

    def requests
      @requests ||= []
    end

    def last_request=(request_signature)
      requests << request_signature
      request_signature
    end
  end
end

WebMock.extend(WebMock::LastRequest)
WebMock.after_request do |request_signature, response|
  WebMock.last_request = request_signature
end

RSpec.configure do |config|
  config.before do
    WebMock.reset!
  end
end
