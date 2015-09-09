module Togls
  module ToggleRepositoryDrivers
    class InMemoryDriver
      def initialize
        @toggles = {}
      end

      def store(toggle_id, toggle_data)
        @toggles[toggle_id] = toggle_data
      end

      def get(toggle_id)
        @toggles[toggle_id]
      end

      def all
        @toggles
      end
    end
  end
end
