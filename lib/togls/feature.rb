module Togls
  class Feature
    attr_reader :key, :description

    def initialize(key, description, base_rule_klass)
      @key = key
      @description = description
      @base_rule_klass = base_rule_klass
      off
    end

    def on(rule = nil)
      if rule.nil?
        rule = @base_rule_klass.new(true)
      end
      @rule = rule 
      self
    end

    alias_method :on_for, :on

    def off
      @rule = @base_rule_klass.new(false)
      self
    end

    def on?(target = nil)
      @rule.run(@key, target)
    end

    def to_s
      if @rule.is_a?(@base_rule_klass)
        display_value = @rule.run(@key) ? ' on' : 'off'
      else
        display_value = '  ?'
      end

      "#{display_value} - #{@key.inspect} - #{@description}"
    end
  end
end
