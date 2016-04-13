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
      def self.title
        "Group"
      end

      def self.description
        %Q{
The Group rule type allows you to define arbitrary groups. The way it
works is that you specify the initialization data as the array of
identifiers inclusively included in the group. Then when the feature
toggle is evaluated you would pass the target and if that target exists
in the inclusive list then it would evaluate to on. If not, it would
evaluate to false. Examples:

# Group defined by user ids
alpha_testers = Togls::Rules::Group.new([23, 343, 222, 123])

# Group defined by email addresses
beta_testers = Togls::Rules::Group.new(['bob@example.com', 'cindy@example.com'])
        }
      end

      def run(_key, target)
        @data.include?(target)
      end
    end
  end
end
