module Togls
  class RuleTypeRegistry
    def initialize(rule_type_repository)
      @rule_type_repository = rule_type_repository
    end

    def expand(&block)
      instance_eval(&block)
      self
    end

    def register(type_id, klass)
      verify_uniqueness_of_type_id(type_id)
      verify_uniqueness_of_rule_type_klass(klass)
      @rule_type_repository.store(type_id, klass)
    end

    def verify_uniqueness_of_type_id(type_id)
      if @rule_type_repository.include?(type_id)
        raise RuleTypeAlreadyDefined, "Rule Type identified by '#{type_id}' has already been registered"
      end
    end

    def verify_uniqueness_of_rule_type_klass(klass)
      if @rule_type_repository.include_klass?(klass)
        raise RuleTypeAlreadyDefined, "Rule Type with class '#{klass}' has already been registered"
      end
    end

    def get(type_id)
      @rule_type_repository.get_klass(type_id)
    end
  end
end
