module Togls
  # Feature
  #
  # The Feature model is the business representation of a feature. It is how
  # Togls primarily interfaces with the concept of a feature.
  class Feature
    attr_reader :key, :description

    def initialize(key, description, target_type)
      @key = key.to_s
      @description = description
      @target_type = target_type
      raise Togls::FeatureMissingTargetType, "Feature '#{self.key}' is missing a required target type" if self.missing_target_type?
    end

    def target_type
      return @target_type unless @target_type.nil?
      return Togls::TargetTypes::NOT_SET
    end

    def id
      @key
    end

    def missing_target_type?
      return false if target_type && (target_type != Togls::TargetTypes::NOT_SET)
      return true
    end
  end
end
