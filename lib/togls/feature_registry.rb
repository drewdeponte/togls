module Togls
  class FeatureRegistry
    def initialize(base_rule_klass)
      @base_rule_klass = base_rule_klass
      @registry = {}
      @default_feature = Feature.new(:default,
                                     "the official default feature",
                                     @base_rule_klass).on(Rule.new { false })
    end

    def self.create(base_rule_klass, &features)
      feature_registry = self.new(base_rule_klass)
      feature_registry.instance_eval(&features) 
      feature_registry
    end

    def feature(tag, desc)
      @registry[tag.to_sym] = Feature.new(tag.to_sym, desc,
                                          @base_rule_klass)
    end

    def get(key)
      @registry.fetch(key) do |key|
        Togls.logger.warn("Feature identified by #{key} has not been defined")
        @default_feature
      end
    end

    def registry
      @registry
    end
  end
end
