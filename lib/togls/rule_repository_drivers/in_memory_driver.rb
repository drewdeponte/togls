module Togls
  module RuleRepositoryDrivers
    class InMemoryDriver
      def initialize
        @rules = {}
      end

      def store(rule)
        extract_storage_payload(rule)
      end

      def extract_storage_payload(rule)

      end
    end
  end
end
