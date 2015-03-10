module Togl
  class Feature
    attr_reader :key

    def initialize(key)
      @key = key
    end

    def on
      @state = :on
    end
    
    def on?
      @state == :on
    end
  end
end
