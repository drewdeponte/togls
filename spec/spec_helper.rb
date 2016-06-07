require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'togls'

require 'pry'

RSpec.configure do |c|
  c.disable_monkey_patching!
  c.order = :random
  c.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  c.around(:each) do |example|
    # store and reset the default feature target type for each test
    save_default_feature_target_type = Togls.default_feature_target_type
    Togls.instance_variable_set(:@default_feature_target_type, nil)

    # reset the release blocks for each test
    Togls.instance_variable_set(:@release_blocks, [])

    # reset the rule type repository and registry before each test
    Togls.instance_variable_set(:@rule_type_repository, nil)
    Togls.instance_variable_set(:@rule_type_registry, nil)

    # reset the feature and toggle repository/registry before each test
    Togls.instance_variable_set(:@release_toggle_registry, nil)
    Togls.instance_variable_set(:@feature_repository, nil)

    example.run

    # restore the stored default feature target type now that the test is
    # complete
    Togls.instance_variable_set(:@default_feature_target_type, save_default_feature_target_type)
  end
end
