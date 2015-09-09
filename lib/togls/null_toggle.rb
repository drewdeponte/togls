module Togls
  class NullToggle < Togls::Toggle
    def initialize
      feature = Togls::Feature.new("null", "the official null feature")
      super(feature)
    end

    def on
      self
    end

    def off
      self
    end
  end
end
