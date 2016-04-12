module Togls
  module RuleRepositoryDrivers
    # Rule Repository Environment Override Driver
    #
    # The Rule Repository Environment Driver provides the interface to store and
    # retrieve rules. This is intended to be used by a Rule Repository instance.
    class EnvOverrideDriver
      def store(rule_id, rule_data)
      end

      def get(rule_id)
        if rule_id == Togls::Helpers.sha1(Togls::Rules::Boolean, true) 
          return { 'type_id' => 'boolean', 'data' => true }
        elsif rule_id == Togls::Helpers.sha1(Togls::Rules::Boolean, false)
          return { 'type_id' => 'boolean', 'data' => false }
        else
          nil
        end
      end
    end
  end
end
