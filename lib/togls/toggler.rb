module Togls
  class Toggler
    def initialize(toggle_repository, toggle)
      @toggle_repository = toggle_repository
      @toggle = toggle
    end

    def on(rule = nil)
      if rule.nil?
        rule = Togls::Rules::Boolean.new(true)
      end
      @toggle.rule = rule
      @toggle_repository.store(@toggle)
      @toggle
    end

    def off
      rule = Togls::Rules::Boolean.new(false)
      @toggle.rule = rule
      @toggle_repository.store(@toggle)
      @toggle
    end
  end
end
