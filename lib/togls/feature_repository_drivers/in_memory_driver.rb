module Togls
  module FeatureRepositoryDrivers
    class InMemoryDriver
      def initialize
        @features = {}
      end

      def store(feature)
        @features[feature.id] = extract_storage_payload(feature)
      end

      def extract_storage_payload(feature)
        { "key" => feature.key, "description" => feature.description }
      end
    end
  end
end
