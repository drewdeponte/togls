module Togl
  class FeatureRegistry
    def initialize
      @registry = {}
    end

    def self.create(&features)
      registry = self.new
      registry.instance_eval(&features) 
      registry
    end

    def feature(tag)
      @registry[tag.to_sym] = Feature.new(tag.to_sym)
    end

    def get(key)
      @registry[key]
    end
  end
end
