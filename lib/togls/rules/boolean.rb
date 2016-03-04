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
      def run(_key, _target = nil)
        @data
      end
    end
  end
end
