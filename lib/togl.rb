require "togl/version"
require "togl/feature_registry"
require "togl/feature"
require "togl/rule"
require "togl/rules"

module Togl
  def self.features(&features)
    @feature_registry = FeatureRegistry.create(&features)
  end
  
  def self.feature(key)
    @feature_registry.get(key)
  end
end


