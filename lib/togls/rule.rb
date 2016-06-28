module Togls
  # Rule
  #
  # The Rule is an abstract base class that is intended to act as an interface
  # for other rules to be implemented against.
  class Rule
    attr_reader :data, :type_id, :id

    def self.title
      raise Togls::NotImplemented, "Rule type title not implemented"
    end

    def self.description
      raise Togls::NotImplemented, "Rule type description not implemented"
    end

    def self.target_type
      Togls::TargetTypes::NOT_SET
    end

    def initialize(id, type_id, data = nil, target_type: Togls::TargetTypes::NOT_SET)
      @id = id
      @type_id = type_id
      @data = data
      @target_type = target_type
      raise Togls::RuleMissingTargetType, "Rule '#{self.id}' of type '#{self.class}' is missing a required target type" if self.missing_target_type?
    end

    def run(key, target = nil)
      raise Togls::NotImplemented, "Rule's #run method must be implemented"
    end

    def target_type
      return @target_type if @target_type && @target_type != Togls::TargetTypes::NOT_SET
      return self.class.target_type unless self.class.target_type.nil?
      return Togls::TargetTypes::NOT_SET
    end

    def missing_target_type?
      return false if target_type && (target_type != Togls::TargetTypes::NOT_SET)
      return true
    end
  end
end
