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
      @rule_type_repository.store(type_id, klass)
    end

    def get(type_id)
      @rule_type_repository.get_klass(type_id)
    end
  end
end
