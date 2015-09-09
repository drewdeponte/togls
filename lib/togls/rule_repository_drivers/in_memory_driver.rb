module Togls
  module RuleRepositoryDrivers
    class InMemoryDriver
      def initialize
        @rules = {}
      end

      def store(rule_id, rule_data)
        @rules[rule_id] = rule_data
      end
      
      def get(rule_id)
        @rules[rule_id]
      end
    end
  end
end
