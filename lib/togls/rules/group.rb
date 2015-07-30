module Togls
  module Rules
    class Group < Rule
      def initialize(list)
        @list = list
      end

      def run(key, target)
        @list.include?(target)
      end
    end
  end
end
