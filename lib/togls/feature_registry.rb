module Togls
  class FeatureRegistry
    def initialize
      @registry = {}
      @default_feature = Feature.new(:default).tap {|f| f.on(Rule.new { false }) }
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
      @registry.fetch(key) do |key|
        Togls.logger.warn("Feature identified by #{key} has not been defined")
        @default_feature
      end
    end
  end
end
