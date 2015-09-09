module Togls
  class Toggle
    attr_reader :feature
    attr_accessor :rule

    def initialize(feature)
      @feature = feature
      @rule = Togls::Rules::Boolean.new(false)
    end

    def id
      @feature.id
    end

    def on?(target = nil)
      @rule.run(@feature.key, target)
    end

    def to_s
      if @rule.is_a?(Togls::Rules::Boolean)
        display_value = @rule.run(@feature.key) ? ' on' : 'off'
      else
        display_value = '  ?'
      end

      "#{display_value} - #{@feature.key} - #{@feature.description}"
    end
  end
end
