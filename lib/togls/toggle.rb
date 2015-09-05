module Togls
  class Toggle
    attr_reader :feature, :rule

    def initialize(feature, base_rule_type_klass)
      @feature = feature
      @base_rule_type_klass = base_rule_type_klass
      @rule = Togls::Rules::Boolean.new(false)
    end

    def on(rule = nil)
      if rule.nil?
        rule = @base_rule_type_klass.new(true)
      end
      @rule = rule
      self
    end

    def off
      @rule = @base_rule_type_klass.new(false)
      self
    end

    def on?(target = nil)
      @rule.run(@feature.key, target)
    end

    def to_s
      if @rule.is_a?(@base_rule_type_klass)
        display_value = @rule.run(@feature.key) ? ' on' : 'off'
      else
        display_value = '  ?'
      end

      "#{display_value} - #{@feature.key} - #{@feature.description}"
    end
  end
end
