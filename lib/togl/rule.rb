module Togl
  class Rule
    def initialize(&rule)
      @definition = rule  
    end

    def run(target = nil)
      @definition.call(target)
    end
  end
end
