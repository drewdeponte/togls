require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'togls'

require 'pry'

RSpec.configure do |c|
  c.before(:each) do
    Togls.instance_variable_set(:@release_toggle_registry, nil)
    Togls.instance_variable_set(:@feature_repository, nil)
    #Togls.instance_variable_set(:@rule_type_repository, nil)
    #Togls.instance_variable_set(:@rule_type_registry, nil)
  end
end
