module Togls
  # Test Toggle Registry
  #
  # The Test Toggle Registry is a toggle feature toggle registry specifically
  # intended to be used in the use case of automated test suites. The difference
  # between this toggle registry and the normal FeatureToggleRegistry is that
  # this registry only uses in-memory drivers and the FeatureToggleRegistry uses
  # in-memory drivers as well as the environment override drivers.
  class TestToggleRegistry < FeatureToggleRegistry
    def initialize(&block)
      @toggle_repository_drivers = [
        Togls::ToggleRepositoryDrivers::InMemoryDriver.new]
      @feature_repository_drivers =
        [Togls::FeatureRepositoryDrivers::InMemoryDriver.new]
      @rule_repository_drivers =
        [Togls::RuleRepositoryDrivers::InMemoryDriver.new]
      @feature_repository = Togls::FeatureRepository.new(
        @feature_repository_drivers)
      @rule_repository = Togls::RuleRepository.new(@rule_repository_drivers)
      @toggle_repository = Togls::ToggleRepository.new(
        @toggle_repository_drivers, @feature_repository, @rule_repository)
      @rule_repository.store(Togls::Rules::Boolean.new(true))
      @rule_repository.store(Togls::Rules::Boolean.new(false))
      self.instance_eval(&block) if block_given?
    end
  end
end
