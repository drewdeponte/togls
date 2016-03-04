module Togls
  module Rules
    # Group Rule
    #
    # The Group Rule is a provided Rule that expects to be given an Array as
    # it's initialization data and when evaluated determines the toggle state
    # based on the given target being included in the Array that was passed in
    # during initialization. This allows you to define various groups. For
    # example:
    #
    # alpha_testers = Togls::Rules::Group.new(['bob@ex.com', 'cindy@ex.com'])
    # Togls.features do
    #   feature(:foo).on(alpha_testers)
    # end
    #
    # if Togls.feature(:foo).on?(current_user.email)
    #   ...
    # end
    class Group < Rule
      def run(_key, target)
        @data.include?(target)
      end
    end
  end
end
