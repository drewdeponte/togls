require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'togls'

require 'pry'

RSpec.configure do |c|
  c.before(:example) do
    Togls.features = nil
  end
end
