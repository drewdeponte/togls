require 'thread'

module Togls
  module RuleRepositoryDrivers
    class InMemoryDriver
      def initialize
        @rules = {}
        @rules_lock = Mutex.new
      end

      def store(rule_id, rule_data)
        @rules_lock.synchronize do
          @rules[rule_id] = rule_data
        end
      end
      
      def get(rule_id)
        @rules_lock.synchronize do
          @rules[rule_id]
        end
      end
    end
  end
end
