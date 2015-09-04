module Togls
  class FeatureToggleRegistry
    attr_reader :registry

    def initialize(base_rule_type_klass)
      @registry = {}
      @base_rule_type_klass = base_rule_type_klass
    end

    def self.create(base_rule_type_klass, &feature_toggles)
      feature_toggle_registry = self.new(base_rule_type_klass)
      feature_toggle_registry.instance_eval(&feature_toggles)
      return feature_toggle_registry
    end

    def feature(key, desc)
      feature = Togls::Feature.new(key, desc)
      toggle = Togls::Toggle.new(feature, @base_rule_type_klass)
      @registry[key.to_s] = toggle
    end

    def get(key)
      @registry.fetch(key.to_s) do |key|
        Togls.logger.warn("Feature identified by #{key} has not been defined")
        default_toggle
      end
    end

    def default_toggle
      return @default_toggle if @default_toggle
      key = "default"
      desc = "the offical Togls default feature"
      feature = Togls::Feature.new(key, desc)
      @default_toggle = Togls::Toggle.new(feature, @base_rule_type_klass).on(Togls::Rule.new { false })
    end
  end
end
