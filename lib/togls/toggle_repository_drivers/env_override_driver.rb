module Togls
  module ToggleRepositoryDrivers
    # Toggle Repository Environment Override Driver
    #
    # The Toggle Repository Environment Override Driver provides a Toggle
    # Repository driver that passively ignores requests to store toggles but
    # still responds to retrieval requests. This conceptually makes it what I am
    # referring to as an "Override Driver" because it only allows retrieving
    # overrides from the store.
    #
    # In this particular case it is an Environment Override Driver. Therefore,
    # the store that backs this driver is environment variables. Specifically,
    # this driver would retrieve a boolean rule initialized true if the
    # associated environment variable was equal to the string, 'true'. If the
    # associated environment variable was equal to the string, 'false', it would
    # return a boolean rule initialized to false. Any other value and the driver
    # returns nil indicating that it couldn't find the toggle in the store.
    class EnvOverrideDriver
      def store(toggle_id, toggle_data)
      end

      def get(toggle_id)
        return nil if ENV[toggle_env_key(toggle_id)].nil?
        if ENV[toggle_env_key(toggle_id)] == 'true'
          return { 'feature_id' => toggle_id, 'rule_id' =>
                   Togls::Rules::Boolean.new(:boolean, true).id }
        elsif ENV[toggle_env_key(toggle_id)] == 'false'
          return { 'feature_id' => toggle_id, 'rule_id' =>
                   Togls::Rules::Boolean.new(:boolean, false).id }
        else
          return nil
        end
      end

      private

      def toggle_env_key(toggle_id)
        "TOGLS_#{toggle_id.to_s.upcase}"
      end
    end
  end
end
