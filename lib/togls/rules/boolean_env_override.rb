require_relative 'boolean'

module Togls
  module Rules
    class BooleanEnvOverride < Boolean
      def run(target = nil)
        if ENV[feature_env_key]
          if ENV[feature_env_key] == "true"
            return true
          else
            return false
          end
        else
          return @bool
        end
      end

      private

      def feature_env_key
        return "TOGLS_#{@feature_key.to_s.upcase}"
      end
    end
  end
end
