require "togls/version"
require "togls/errors"
require "togls/helpers"
require "togls/toggle_repository_drivers"
require "togls/toggle_repository_drivers/in_memory_driver"
require "togls/toggle_repository_drivers/env_override_driver"
require "togls/feature_repository_drivers"
require "togls/feature_repository_drivers/in_memory_driver"
require "togls/rule_repository_drivers"
require "togls/rule_repository_drivers/in_memory_driver"
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
  def self.features(&block)
    if @feature_toggle_registry.nil?
      @feature_toggle_registry = FeatureToggleRegistry.new
    end

    if block
      @feature_toggle_registry.expand(&block)
    end

    return @feature_toggle_registry
  end

  def self.features=(feature_toggle_registry)
    @feature_toggle_registry = feature_toggle_registry
  end
  
  def self.feature(key)
    if @feature_toggle_registry.nil?
      @feature_toggle_registry = FeatureToggleRegistry.new
    end

    return @feature_toggle_registry.get(key)
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
end
