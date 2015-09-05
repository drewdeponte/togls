require "togls/version"
require "togls/errors"
require "togls/toggle_repository_drivers"
require "togls/toggle_repository_drivers/in_memory_driver"
require "togls/feature_repository_drivers"
require "togls/feature_repository_drivers/in_memory_driver"
require "togls/rule_repository_drivers"
require "togls/rule_repository_drivers/in_memory_driver"
require "togls/rule_repository_drivers/env_driver"
require "togls/toggler"
require "togls/feature_toggle_registry"
require "togls/feature_repository"
require "togls/rule_repository"
require "togls/toggle_repository"
require "togls/feature"
require "togls/toggle"
require "togls/null_toggle"
require "togls/rule"
require "togls/rules"
require "logger"

module Togls
  def self.features(base_rule_type_klass = Togls::Rules::Boolean, &feature_toggles)
    if !feature_toggles.nil?
      @feature_toggle_registry = FeatureToggleRegistry.create(base_rule_type_klass, &feature_toggles)
    else
      if @feature_toggle_registry.nil?
        raise Togls::NoFeaturesError, "Need to define features before you can get them"
      else
        @feature_toggle_registry.registry
      end
    end
  end
  
  def self.feature(key)
    return @feature_toggle_registry.get(key)
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
end
