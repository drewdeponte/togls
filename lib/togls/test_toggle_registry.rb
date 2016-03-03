module Togls
  class TestToggleRegistry < FeatureToggleRegistry
    def initialize
      @toggle_repository_drivers = [
        Togls::ToggleRepositoryDrivers::InMemoryDriver.new]
      @feature_repository_drivers =
        [Togls::FeatureRepositoryDrivers::InMemoryDriver.new]
      @rule_repository_drivers =
        [Togls::RuleRepositoryDrivers::InMemoryDriver.new]
      @feature_repository = Togls::FeatureRepository.new(@feature_repository_drivers)
      @rule_repository = Togls::RuleRepository.new(@rule_repository_drivers)
      @toggle_repository = Togls::ToggleRepository.new(@toggle_repository_drivers,
                                    @feature_repository, @rule_repository)
      @boolean_true_rule = Togls::Rules::Boolean.new(true)
      @boolean_false_rule = Togls::Rules::Boolean.new(false)
      @rule_repository.store(@boolean_false_rule)
      @rule_repository.store(@boolean_true_rule)
    end
  end
end
