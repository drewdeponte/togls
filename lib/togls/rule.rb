module Togls
  # Rule
  #
  # The Rule is an abstract base class that is intended to act as an interface
  # for other rules to be implemented against.
  class Rule
    attr_reader :data

    def self.title
      raise Togls::NotImplemented, "Rule type title not implemented"
    end

    def self.description
      raise Togls::NotImplemented, "Rule type description not implemented"
    end

    def self.target_type
      Togls::TargetTypes::NOT_SET
    end

    def initialize(data = nil, target_type: Togls::TargetTypes::NOT_SET)
      @data = data
      @target_type = target_type
    end

    def run(key, target = nil)
      raise Togls::NotImplemented, "Rule's #run method must be implemented"
    end

    def id
      Togls::Helpers.sha1(self.class, @data)
    end

    def target_type
      return @target_type if @target_type && @target_type != Togls::TargetTypes::NOT_SET
      return self.class.target_type unless self.class.target_type.nil?
      return Togls::TargetTypes::NOT_SET
    end
  end
end
