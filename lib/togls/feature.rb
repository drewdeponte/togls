module Togls
  # Feature
  #
  # The Feature model is the business representation of a feature. It is how
  # Togls primarily interfaces with the concept of a feature.
  class Feature
    attr_reader :key, :description, :target_type

    def initialize(key, description, target_type = :any)
      @key = key.to_s
      @description = description
      @target_type = target_type
    end

    def id
      @key
    end
  end
end
