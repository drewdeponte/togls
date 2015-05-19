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
        rule = Rule.new { true }
      end
      @rule = rule 
    end

    def off
      @rule = Rule.new { false }
    end

    def on?(target = nil)
      @rule.run(target)
    end
  end
end
