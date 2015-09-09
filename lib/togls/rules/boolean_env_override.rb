require_relative 'boolean'

module Togls
  module Rules
    class BooleanEnvOverride < Boolean
      def run(key, target = nil)
        if ENV[feature_env_key(key)]
          if ENV[feature_env_key(key)] == "true"
            return true
          else
            return false
          end
        else
          return @data
        end
      end

      private

      def feature_env_key(feature_key)
        return "TOGLS_#{feature_key.to_s.upcase}"
      end
    end
  end
end
