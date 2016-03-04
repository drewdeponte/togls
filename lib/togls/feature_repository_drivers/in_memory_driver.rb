require 'thread'

module Togls
  module FeatureRepositoryDrivers
    # Feature Repository In-Memory Driver
    #
    # The Feature Repository In-Memory Driver provides the facility to store and
    # retrieve features to and from the in-memory store.
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
