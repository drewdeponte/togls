module Togls
  module ReleaseToggleRegistryManager
    def self.included(mod)
      mod.extend(ClassMethods)
    end

    module ClassMethods
      def features(&block)
        if @feature_toggle_registry.nil?
          @feature_toggle_registry = FeatureToggleRegistry.new
        end

        if block
          @feature_toggle_registry.expand(&block)
        end

        return @feature_toggle_registry
      end

      def features=(feature_toggle_registry)
        @feature_toggle_registry = feature_toggle_registry
      end

      def feature(key)
        if @feature_toggle_registry.nil?
          @feature_toggle_registry = FeatureToggleRegistry.new
        end

        return @feature_toggle_registry.get(key)
      end

      def logger
        @logger ||= Logger.new(STDOUT)
      end
    end
  end
end
