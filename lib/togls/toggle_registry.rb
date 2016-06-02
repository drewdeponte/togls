module Togls
  # Toggle Registry
  #
  # The Toggle Registry conceptually houses a registry of toggles. It
  # accomplishes this by interfacing with the provided feature
  # repository, and toggle repository. This plays a significant portion
  # in the primary DSL as well.
  class ToggleRegistry
    def initialize(feature_repository, toggle_repository)
      @feature_repository = feature_repository
      @toggle_repository = toggle_repository
    end

    def expand(&block)
      instance_eval(&block)
      self
    end

    def feature(key, desc, target_type: Togls::TargetTypes::ANY)
      verify_uniqueness_of_feature(key)
      feature = Togls::Feature.new(key, desc, target_type)
      toggle = Togls::Toggle.new(feature)
      @toggle_repository.store(toggle)
      Togls::Toggler.new(@toggle_repository, toggle)
    end

    def verify_uniqueness_of_feature(key)
      if @feature_repository.include?(key.to_s)
        raise FeatureAlreadyDefined, "Feature identified by '#{key}' has already been defined"
      end
    end

    def get(key)
      toggle = @toggle_repository.get(key.to_s)
      if toggle.is_a?(Togls::ToggleMissingToggle)
        Togls.logger.warn("Feature identified by '#{key}' has not been defined")
      end
      toggle
    end

    def all
      @toggle_repository.all
    end
  end
end
