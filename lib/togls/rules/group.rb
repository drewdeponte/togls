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
The Group rule allows you to define an arbitrary collection of objects to be
used in evaluating against the target. Specify the initialization data as an
array of inclusive identifiers for the group. When the feature toggle is
evaluated if the passed in target is included in the group then it is evaluated
to on. If not, it evaluates to off. Examples:

# Group defined by user ids
alpha_testers = Togls::Rules::Group.new([23, 343, 222, 123])

# Group defined by email addresses
beta_testers = Togls::Rules::Group.new(['bob@example.com', 'cindy@example.com'])

Togls.release do
  feature(:foo, 'some foo desc').on(beta_testers)
end

Togls.feature(:foo).on?('jack@example.com') # evalutes to false (a.k.a. off)
        }
      end

      def run(_key, target)
        @data.include?(target)
      end
    end
  end
end
