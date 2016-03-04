module Togls
  # Null Toggle
  #
  # The Null Toggle model is designed to be used as a response when there is no
  # toggle found when requested to be retreived through a Toggle Repository.
  class NullToggle < Togls::Toggle
    def initialize
      feature = Togls::Feature.new('null', 'the official null feature')
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
