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
        release_blocks << block if block
        
        release_toggle_registry.expand(&block) if block
        release_toggle_registry
      end

      def release_blocks
        @release_blocks ||= []
      end

      def rule_types(&block)
        rule_type_registry.expand(&block) if block
        rule_type_registry
      end

      def rule_type(type_id)
        rule_type_registry.get(type_id)
      end

      def rule(type_id, data, target_type: Togls::TargetTypes::NOT_SET)
        rule_type(type_id).new(type_id, data, target_type: target_type)
      end

      def feature(key)
        Toggler.new(release_toggle_registry.instance_variable_get(:@toggle_repository), release_toggle_registry.get(key))
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

      def rule_type_repository
        if @rule_type_repository.nil?
          rule_type_repository_drivers = [RuleTypeRepositoryDrivers::InMemoryDriver.new]
          @rule_type_repository = RuleTypeRepository.new(rule_type_repository_drivers)
        end
        @rule_type_repository
      end

      def rule_type_registry
        if @rule_type_registry.nil?
          @rule_type_registry = RuleTypeRegistry.new(rule_type_repository)
          @rule_type_registry.register(:boolean, Togls::Rules::Boolean)
          @rule_type_registry.register(:group, Togls::Rules::Group)
        end
        @rule_type_registry
      end

      def test_toggle_registry
        feature_repository_drivers =
          [Togls::FeatureRepositoryDrivers::InMemoryDriver.new]
        test_feature_repository = Togls::FeatureRepository.new(
          feature_repository_drivers)

        rule_repository_drivers =
          [Togls::RuleRepositoryDrivers::InMemoryDriver.new]
        rule_repository = Togls::RuleRepository.new(rule_type_registry, rule_repository_drivers)

        toggle_repository_drivers = [
          Togls::ToggleRepositoryDrivers::InMemoryDriver.new]

        toggle_repository = Togls::ToggleRepository.new(
          toggle_repository_drivers, test_feature_repository, rule_repository)

        tr = ToggleRegistry.new(test_feature_repository, toggle_repository)
        release_blocks.each do |p|
          tr.expand(&p)
        end

        return tr
      end

      def release_toggle_registry
        if @release_toggle_registry.nil?
          rule_repository_drivers = [
            Togls::RuleRepositoryDrivers::InMemoryDriver.new,
            Togls::RuleRepositoryDrivers::EnvOverrideDriver.new
          ]

          rule_repository = Togls::RuleRepository.new(rule_type_registry, rule_repository_drivers)

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
