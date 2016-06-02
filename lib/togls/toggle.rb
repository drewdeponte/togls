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

    # feature target type | rule target type | match?
    # ------------------------------------------------
    # any (aka none)      | any              | true
    # something (foo)     | any              | true
    # any (aka none)      | something (foo)  | false
    # something (foo)     | something (foo)  | true
    # something (foo)     | something (bar)  | false
    def target_matches?(rule)
      @feature.target_type == rule.class.target_type ||
        rule.class.target_type == Togls::TargetTypes::ANY
    end

    def on?(target = nil)
      @rule.run(@feature.key, target)
    end

    def off?(target = nil)
      !@rule.run(@feature.key, target)
    end

    def to_s
      display_value = if @rule.is_a?(Togls::Rules::Boolean)
                        @rule.run(@feature.key) ? ' on' : 'off'
                      else
                        '  ?'
                      end

      "#{display_value} - #{@feature.key} - #{@feature.description}"
    end
  end
end
