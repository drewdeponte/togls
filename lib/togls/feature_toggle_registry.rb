module Togls
  class FeatureToggleRegistry
    attr_reader :registry

    def initialize(base_rule_type_klass)
      @registry = {}
      @base_rule_type_klass = base_rule_type_klass
      @toggle_repository_drivers =
        [Togls::ToggleRepositoryDrivers::InMemoryDriver.new]
      @feature_repository_drivers =
        [Togls::FeatureRepositoryDrivers::InMemoryDriver.new]
      @rule_repository_drivers =
        [Togls::RuleRepositoryDrivers::InMemoryDriver.new]
    end

    def self.create(base_rule_type_klass, &feature_toggles)
      feature_toggle_registry = self.new(base_rule_type_klass)
      feature_toggle_registry.instance_eval(&feature_toggles)
      return feature_toggle_registry
    end

    def feature(key, desc)
      feature = Togls::Feature.new(key, desc)
      toggle = Togls::Toggle.new(feature, @base_rule_type_klass)
      feature_repository = Togls::FeatureRepository.new(@feature_repository_drivers)
      rule_repository = Togls::RuleRepository.new(@rule_repository_drivers)
      toggle_repository = Togls::ToggleRepository.new(@toggle_repository_drivers, feature_repository, rule_repository)
      toggle_repository.store(toggle)
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
