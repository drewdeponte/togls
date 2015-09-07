module Togls
  module ToggleRepositoryDrivers
    class EnvOverrideDriver
      def store(toggle_id, toggle_data)
      end

      def get(toggle_id)
        if ENV[toggle_env_key(toggle_id)]
          if ENV[toggle_env_key(toggle_id)] == "true"
            return { "feature_id" => toggle_id,
                     "rule_id" => Togls::Helpers.sha1(Togls::Rules::Boolean, true) }
          else
            return { "feature_id" => toggle_id,
                     "rule_id" => Togls::Helpers.sha1(Togls::Rules::Boolean, false) }
          end
        else
          return nil
        end
      end

      def all
        return {}
      end

      private

      def toggle_env_key(toggle_id)
        return "TOGLS_#{toggle_id.to_s.upcase}"
      end
    end
  end
end
