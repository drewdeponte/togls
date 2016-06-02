module Togls
  # Feature
  #
  # The Feature model is the business representation of a feature. It is how
  # Togls primarily interfaces with the concept of a feature.
  class Feature
    attr_reader :key, :description

    def initialize(key, description, target_type = Togls::TargetTypes::NOT_SET)
      @key = key.to_s
      @description = description
      @target_type = target_type
    end

    def target_type
      return @target_type unless @target_type.nil?
      return Togls::TargetTypes::NOT_SET
    end

    def id
      @key
    end
  end
end
