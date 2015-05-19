module Togls
  class Feature
    attr_reader :key, :description

    def initialize(key, description)
      @key = key
      @description = description
      off
    end

    def on(rule = nil)
      if rule.nil?
        rule = Togls::Rules::Boolean.new(true)
      end
      @rule = rule 
      self
    end

    def off
      @rule = Togls::Rules::Boolean.new(false)
      self
    end

    def on?(target = nil)
      @rule.run(target)
    end

    def to_s
      if @rule.is_a?(Togls::Rules::Boolean)
        display_value = @rule.run ? ' on' : 'off'
      else
        display_value = '  ?'
      end

      "#{display_value} - #{@key.inspect} - #{@description}"
    end
  end
end
