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

      private

      def test_toggle_registry
        TestToggleRegistry.new
      end

      def release_toggle_registry
        if @release_toggle_registry.nil?
          @release_toggle_registry = ReleaseToggleRegistry.new(feature_repository)
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
