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
      Digest::SHA1.hexdigest("#{self.class}:#{@data.to_s}")
    end
  end
end
