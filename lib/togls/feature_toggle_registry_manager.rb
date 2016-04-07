module Togls
  # Feature Toggle Registry Manager
  #
  # This is the primary DSL interface. It provides a DSL to facilitate housing
  # and managing a toggle registry.
  module FeatureToggleRegistryManager
    def self.included(mod)
      mod.extend(ClassMethods)
    end

    # Feature Toggle Registry Manager Class Methods
    #
    # The class methods that should be extended onto the module/class when
    # FeatureToggleRegistryManager is included.
    module ClassMethods
      def release(&block)
        release_toggle_registry.expand(&block) if block
        release_toggle_registry
      end

      def feature(key)
        release_toggle_registry.get(key)
      end

      def logger
        @logger ||= Logger.new(STDOUT)
      end

      def enable_test_mode
        @previous_release_toggle_registry = @release_toggle_registry
        @release_toggle_registry = test_toggle_registry
      end

      def disable_test_mode
        @release_toggle_registry = @previous_release_toggle_registry
      end

      def test_mode
        enable_test_mode
        yield
        disable_test_mode
      end

      private

      def test_toggle_registry
        feature_repository_drivers =
          [Togls::FeatureRepositoryDrivers::InMemoryDriver.new]
        feature_repository = Togls::FeatureRepository.new(
          feature_repository_drivers)

        rule_repository_drivers =
          [Togls::RuleRepositoryDrivers::InMemoryDriver.new]
        rule_repository = Togls::RuleRepository.new(rule_repository_drivers)
        rule_repository.store(Togls::Rules::Boolean.new(true))
        rule_repository.store(Togls::Rules::Boolean.new(false))

        toggle_repository_drivers = [
          Togls::ToggleRepositoryDrivers::InMemoryDriver.new]

        toggle_repository = Togls::ToggleRepository.new(
          toggle_repository_drivers, feature_repository, rule_repository)

        return ToggleRegistry.new(feature_repository, toggle_repository)
      end

      def release_toggle_registry
        if @release_toggle_registry.nil?
          rule_repository_drivers = [
            Togls::RuleRepositoryDrivers::InMemoryDriver.new
          ]

          rule_repository = Togls::RuleRepository.new(rule_repository_drivers)
          rule_repository.store(Togls::Rules::Boolean.new(true))
          rule_repository.store(Togls::Rules::Boolean.new(false))

          toggle_repository_drivers = [
            Togls::ToggleRepositoryDrivers::InMemoryDriver.new,
            Togls::ToggleRepositoryDrivers::EnvOverrideDriver.new
          ]

          toggle_repository = Togls::ToggleRepository.new(
            toggle_repository_drivers, feature_repository, rule_repository)

          @release_toggle_registry = ToggleRegistry.new(feature_repository,
                                                        toggle_repository)
        end
        @release_toggle_registry
      end

      def feature_repository
        if @feature_repository.nil?
          feature_repository_drivers = [Togls::FeatureRepositoryDrivers::InMemoryDriver.new]
          @feature_repository = Togls::FeatureRepository.new(feature_repository_drivers)
        end
        @feature_repository
      end
    end
  end
end
