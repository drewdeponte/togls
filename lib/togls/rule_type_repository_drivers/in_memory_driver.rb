module Togls
  module RuleTypeRepositoryDrivers
    class InMemoryDriver
      def initialize
        @rule_types = {}
        @rule_type_meta_data = {}
        @type_ids = {}
        @rule_types_lock = Mutex.new
      end

      def store(type_id, klass_str, title, description, target_type)
        @rule_types_lock.synchronize do
          @rule_types[type_id] = klass_str
          @rule_type_meta_data[type_id] = { title: title,
                                            description: description,
                                            target_type: target_type }
          @type_ids[klass_str] = type_id
        end
      end

      def get_klass(type_id)
        @rule_types_lock.synchronize do
          if @rule_types.has_key?(type_id)
            @rule_types[type_id].dup
          else
            nil
          end
        end
      end

      def get_type_meta_data(type_id)
        @rule_types_lock.synchronize do
          if @rule_types.has_key?(type_id)
            @rule_type_meta_data[type_id].dup
          else
            nil
          end
        end
      end

      def get_type_id(klass_str)
        @rule_types_lock.synchronize do
          if @type_ids.has_key?(klass_str)
            @type_ids[klass_str].dup
          else
            nil
          end
        end
      end
    end
  end
end
