module Togls
  module RuleManager
    def self.included(mod)
      mod.extend(ClassMethods)
    end

    module ClassMethods
      def rule_types(&block)
        rule_type_registry.expand(&block) if block
        rule_type_registry
      end

      def rule_type(type_id)
        rule_type_registry.get(type_id)
      end

      def rule(type_id, data = nil, target_type: Togls::TargetTypes::NOT_SET)
        rule_type(type_id).new(type_id, data, target_type: target_type)
      end

      private

      def rule_type_repository
        if @rule_type_repository.nil?
          rule_type_repository_drivers = [RuleTypeRepositoryDrivers::InMemoryDriver.new]
          @rule_type_repository = RuleTypeRepository.new(rule_type_repository_drivers)
        end
        @rule_type_repository
      end

      def rule_type_registry
        if @rule_type_registry.nil?
          @rule_type_registry = RuleTypeRegistry.new(rule_type_repository)
          @rule_type_registry.register(:boolean, Togls::Rules::Boolean)
          @rule_type_registry.register(:group, Togls::Rules::Group)
        end
        @rule_type_registry
      end

      def rule_repository_drivers
        rule_repository_drivers = [
          Togls::RuleRepositoryDrivers::InMemoryDriver.new,
          Togls::RuleRepositoryDrivers::EnvOverrideDriver.new
        ]
      end

      def rule_repository
        if @rule_repository.nil?
          @rule_repository = Togls::RuleRepository.new(rule_repository_drivers)
        end
        @rule_repository
      end
    end
  end
end
