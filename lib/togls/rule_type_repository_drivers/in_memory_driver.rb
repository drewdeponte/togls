module Togls
  module RuleTypeRepositoryDrivers
    class InMemoryDriver
      def initialize
        @rule_types = {}
        @type_ids = {}
        @rule_types_lock = Mutex.new
      end

      def store(type_id, klass_str, title, description)
        @rule_types_lock.synchronize do
          @rule_types[type_id] = klass_str
          @type_ids[klass_str] = type_id
        end
      end

      def get_klass(type_id)
        @rule_types_lock.synchronize do
          if @rule_types.has_key?(type_id)
            @rule_types[type_id]
          else
            nil
          end
        end
      end

      def get_type_id(klass_str)
        @rule_types_lock.synchronize do
          if @type_ids.has_key?(klass_str)
            @type_ids[klass_str]
          else
            nil
          end
        end
      end
    end
  end
end
