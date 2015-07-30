module Togls
  module Rules
    class Boolean < Rule
      def initialize(bool, feature_key = nil)
        @bool = bool
        @feature_key = feature_key
      end

      def run(target = nil)
        return @bool
      end
    end
  end
end
