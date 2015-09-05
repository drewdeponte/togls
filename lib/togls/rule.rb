module Togls
  class Rule
    def initialize(&rule)
      @definition = rule  
    end

    def run(key, target = nil)
      @definition.call(key, target)
    end

    def id
      Digest::SHA1.hexdigest("#{self.class}#{
    end
  end
end
