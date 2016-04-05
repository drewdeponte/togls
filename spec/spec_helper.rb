require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'togls'

require 'pry'

RSpec.configure do |c|
  c.before(:each) do
    Togls.instance_variable_set(:@feature_toggle_registry, nil)
  end
end
