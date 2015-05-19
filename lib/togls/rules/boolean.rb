module Togls
  module Rules
    class Boolean < Rule
      def initialize(bool)
        @bool = bool
      end

      def run(target = nil)
        return @bool
      end
    end
  end
end
