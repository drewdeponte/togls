require "togls/version"
require "togls/errors"
require "togls/feature_registry"
require "togls/feature"
require "togls/rule"
require "togls/rules"
require "logger"

module Togls
  def self.features(base_rule_type_klass = Togls::Rules::Boolean, &features)
    if !features.nil?
      @feature_registry = FeatureRegistry.create(base_rule_type_klass, &features)
    else
      if @feature_registry.nil?
        raise Togls::NoFeaturesError, "Need to define features before you can get them"
      else
        @feature_registry.registry
      end
    end
  end
  
  def self.feature(key)
    @feature_registry.get(key)
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
end
