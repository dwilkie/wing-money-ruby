$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'wing_money'

RSpec.configure do |config|
  Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}
  Dir[File.dirname(__FILE__) + "/../lib/wing_money/spec_helpers/**/*.rb"].each {|f| require f}

  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = [:should, :expect]
  end
end
