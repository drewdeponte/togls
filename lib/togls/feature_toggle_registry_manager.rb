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

      def test_toggle_registry
        feature_repository_drivers =
          [Togls::FeatureRepositoryDrivers::InMemoryDriver.new]
        test_feature_repository = Togls::FeatureRepository.new(
          feature_repository_drivers)

        toggle_repository_drivers = [
          Togls::ToggleRepositoryDrivers::InMemoryDriver.new]

        toggle_repository = Togls::ToggleRepository.new(
          toggle_repository_drivers, test_feature_repository, ::Togls.send(:rule_repository))

        tr = ToggleRegistry.new(test_feature_repository, toggle_repository)
        release_blocks.each do |p|
          tr.expand(&p)
        end

        return tr
      end

      def release_toggle_registry
        if @release_toggle_registry.nil?

          toggle_repository_drivers = [
            Togls::ToggleRepositoryDrivers::InMemoryDriver.new,
            Togls::ToggleRepositoryDrivers::EnvOverrideDriver.new
          ]

          toggle_repository = Togls::ToggleRepository.new(
            toggle_repository_drivers, feature_repository, ::Togls.send(:rule_repository))

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
