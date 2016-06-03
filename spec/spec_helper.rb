require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'togls'

require 'pry'

RSpec.configure do |c|
  c.before(:each) do
    Togls.instance_variable_set(:@release_toggle_registry, nil)
    Togls.instance_variable_set(:@feature_repository, nil)
    Togls.instance_variable_set(:@rule_type_repository, nil)
    Togls.instance_variable_set(:@rule_type_registry, nil)
  end

  c.around(:each) do |example|
    save_default_feature_target_type = Togls.default_feature_target_type
    # Togls.instance_variable_set(:@default_feature_target_type, :test_target_type)
    Togls.instance_variable_set(:@default_feature_target_type, nil)
    example.run
    Togls.instance_variable_set(:@default_feature_target_type, save_default_feature_target_type)
  end
end
