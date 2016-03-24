require 'thread'

module Togls
  module RuleRepositoryDrivers
    # Rule Repository In-Memory Driver
    #
    # The Rule Repository In-Memory Driver provides the interface to store and
    # retrieve rules. This is intended to be used by a Rule Repository instance.
    class InMemoryDriver
      def initialize
        @rules = {}
        @rules_lock = Mutex.new
      end

      def store(rule_id, rule_data)
        @rules_lock.synchronize do
          @rules[rule_id] = Marshal.dump(rule_data)
        end
      end

      def get(rule_id)
        @rules_lock.synchronize do
          if @rules.has_key?(rule_id)
            Marshal.load(@rules[rule_id])
          else
            nil
          end
        end
      end
    end
  end
end
