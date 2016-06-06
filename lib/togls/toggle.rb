module Togls
  # Toggle
  #
  # The model representing a Toggle within the world of Togls. A Toggle's
  # responsibility is binding a specific rule to a specific feature. Toggle's by
  # default are associated with a boolean rule initialized to false.
  class Toggle
    attr_reader :feature, :rule

    def initialize(feature)
      @feature = feature
      @rule = Togls::Rules::Boolean.new(false)
    end

    def id
      @feature.id
    end

    def rule=(rule)
      raise Togls::RuleFeatureTargetTypeMismatch unless target_matches?(rule)
      @rule = rule
    end

    # feature target type | rule target type | match? | notes
    # -------------------------------------------------------
    # NOT_SET             | NONE             | true   |
    # NONE                | NONE             | true   |
    # something (foo)     | NONE             | true   |
    # NOT_SET             | NOT_SET          | false  | broken - shouldn't happen
    # NONE                | NOT_SET          | false  | broken - shouldn't happen
    # something (foo)     | NOT_SET          | false  | broken - shouldn't happen
    # NOT_SET             | something (foo)  | false  | broken - shouldn't happen
    # NONE                | something (foo)  | false  |
    # something (foo)     | something (foo)  | true   |
    # something (foo)     | something (bar)  | false  |
    def target_matches?(rule)
      if rule.target_type == Togls::TargetTypes::NONE
        return true
      elsif rule.target_type == Togls::TargetTypes::NOT_SET
        Togls.logger.warn "Rule (id: #{rule.id}) cannot have target type of :not_set"
        return false
      elsif @feature.target_type == Togls::TargetTypes::NOT_SET
        Togls.logger.warn "Feature (key: #{feature.key}) cannot have target type of :not_set when rule (id: #{rule.id}) specifies a target type (target_type: #{rule.target_type}"
        return false
      elsif rule.target_type == @feature.target_type
        return true
      else
        false
      end
    end

    # feature.target_type | target.nil? | valid target
    # NONE                | false       | FALSE - EXCEPTION
    # :foo                | true        | FALSE - EXCEPTION
    # NONE                | true        | true
    # :foo                | false       | true
    # NOT_SET             | ignored     | true - broken
    def validate_target(target)
      is_explicit_target_type = @feature.target_type != Togls::TargetTypes::NONE &&
        @feature.target_type != Togls::TargetTypes::NOT_SET &&
        @feature.target_type != Togls::TargetTypes::EITHER
      if @feature.target_type == Togls::TargetTypes::NONE && target
        raise Togls::UnexpectedEvaluationTarget
      elsif is_explicit_target_type && target.nil?
        raise Togls::EvaluationTargetMissing
      end
      # Is valid
    end

    def on?(target = nil)
      validate_target(target)
      @rule.run(@feature.key, target)
    end

    def off?(target = nil)
      validate_target(target)
      !@rule.run(@feature.key, target)
    end
  end
end
