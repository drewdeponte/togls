module Togls
  class Rule
    attr_reader :data

    def initialize(data=nil)
      @data = data  
    end

    def run(key, target = nil)
      raise Togls::NotImplemented.new(
        "Rule's #run method must be implemented"
      )
    end

    def id
      Togls::Helpers.sha1(self.class, @data)
    end
  end
end
