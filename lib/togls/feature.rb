module Togls
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
