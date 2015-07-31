module Togls
  class Rule
    def initialize(&rule)
      @definition = rule  
    end

    def run(key, target = nil)
      @definition.call(key, target)
    end
  end
end
