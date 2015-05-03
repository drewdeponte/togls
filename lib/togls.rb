require "togls/version"
require "togls/feature_registry"
require "togls/feature"
require "togls/rule"
require "togls/rules"
require "logger"

module Togls
  def self.features(&features)
    @feature_registry = FeatureRegistry.create(&features)
  end
  
  def self.feature(key)
    @feature_registry.get(key)
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
end
