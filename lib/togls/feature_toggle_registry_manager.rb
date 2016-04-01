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
      def features(&block)
        feature_toggle_registry.expand(&block) if block
        feature_toggle_registry
      end

      def features=(feature_toggle_registry)
        @feature_toggle_registry = feature_toggle_registry
      end

      def feature(key)
        feature_toggle_registry.get(key)
      end

      def logger
        @logger ||= Logger.new(STDOUT)
      end

      private

      def feature_toggle_registry
        if @feature_toggle_registry.nil?
          @feature_toggle_registry = FeatureToggleRegistry.new(feature_repository)
        end
        @feature_toggle_registry
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
