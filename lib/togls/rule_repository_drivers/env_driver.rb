module Togls
  module RuleRepositoryDrivers
    class EnvDriver
      def store(toggle_id, toggle_data)
      end

      # def feature_env_key(feature_id)
      #   return "TOGLS_#{feature_id.to_s.upcase}"
      # end
      
      # def get(key)
        # if ENV[feature_env_key(key)]
        #   if ENV[feature_env_key(key)] == "true"
        #     return true
        #   else
        #     return false
        #   end
        # else
        #   return @data
        # end

        # { "klass" => Togls::Rules::Boolean, "data" => true }
        # { "klass" => Togls::Rules::Boolean, "data" => false }
      # end
    end
  end
end
