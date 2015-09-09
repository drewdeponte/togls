module Togls
  module Rules
    class Group < Rule
      def run(key, target)
        @data.include?(target)
      end
    end
  end
end
