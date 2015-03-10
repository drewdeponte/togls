module Togl
  module Rules
    class Group < Rule
      def initialize(list)
        @list = list
      end

      def run(target)
        @list.include?(target)
      end
    end
  end
end
