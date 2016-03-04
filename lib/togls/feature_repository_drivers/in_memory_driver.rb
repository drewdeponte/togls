require 'thread'

module Togls
  module FeatureRepositoryDrivers
    class InMemoryDriver
      def initialize
        @features = {}
        @features_lock = Mutex.new
      end

      def store(feature_id, feature_data)
        @features_lock.synchronize do
          @features[feature_id] = feature_data
        end
      end

      def get(feature_id)
        @features_lock.synchronize do
          @features[feature_id]
        end
      end
    end
  end
end
