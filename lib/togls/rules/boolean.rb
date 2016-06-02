module Togls
  module Rules
    # Boolean Rule
    #
    # The Boolean Rule is a provided Rule that expects to be given a boolean as
    # it's initialization data and when evaluated determines the toggle state
    # based on the initialization value. Example:
    #
    # always_on = Togls::Rules::Boolean.new(true)
    # Togls.features do
    #   feature(:foo).on(always_on)
    # end
    #
    # if Togls.feature(:foo).on?
    #   ...
    # end
    class Boolean < Rule
      def self.title
        "Boolean"
      end

      def self.description
        %Q{
The Boolean rule type is the base line rule for Togls. It allows you to
flag a feature on/off by specifing a boolean value as the initialization
data. For example:

Togls::Rules::Boolean.new(true) # rule that always evaluates to on

Togls::Rules::Boolean.new(false) # rule that always evaluates to off
        }
      end

      def self.target_type
        Togls::TargetTypes::NONE
      end

      def run(_key, _target = nil)
        @data
      end
    end
  end
end
