module Togls
  # Feature
  #
  # The Feature model is the business representation of a feature. It is how
  # Togls primarily interfaces with the concept of a feature.
  class Feature
    attr_reader :key, :description

    def initialize(key, description)
      @key = key.to_s
      @description = description
    end

    def id
      @key
    end
  end
end
