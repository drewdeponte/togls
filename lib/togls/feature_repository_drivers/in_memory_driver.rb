module Togls
  module FeatureRepositoryDrivers
    class InMemoryDriver
      def initialize
        @features = {}
      end

      def store(feature_id, feature_data)
        @features[feature_id] = feature_data
      end

      def get(feature_id)
        @features[feature_id]
      end
    end
  end
end
