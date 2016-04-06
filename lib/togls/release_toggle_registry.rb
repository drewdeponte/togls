module Togls
  # Release Toggle Registry
  #
  # The Release Toggle Registry conceptually houses a registry of toggles. It
  # accomplishes this by technically housing a toggle repository, and a rule
  # repository which it uses to store and retrieve the respective
  # entities. This plays a significant portion in the primary DSL as well.
  class ReleaseToggleRegistry
    def initialize(feature_repository)
      @feature_repository = feature_repository
      @toggle_repository_drivers = [
        Togls::ToggleRepositoryDrivers::InMemoryDriver.new,
        Togls::ToggleRepositoryDrivers::EnvOverrideDriver.new]
      @rule_repository_drivers =
        [Togls::RuleRepositoryDrivers::InMemoryDriver.new]
      @rule_repository = Togls::RuleRepository.new(@rule_repository_drivers)
      @toggle_repository = Togls::ToggleRepository.new(
        @toggle_repository_drivers, @feature_repository, @rule_repository)
      @rule_repository.store(Togls::Rules::Boolean.new(true))
      @rule_repository.store(Togls::Rules::Boolean.new(false))
    end

    def expand(&block)
      instance_eval(&block)
      self
    end

    def feature(key, desc)
      verify_uniqueness_of_feature(key)
      feature = Togls::Feature.new(key, desc)
      toggle = Togls::Toggle.new(feature)
      @toggle_repository.store(toggle)
      Togls::Toggler.new(@toggle_repository, toggle)
    end

    def verify_uniqueness_of_feature(key)
      if @feature_repository.exist?(key.to_s)
        raise FeatureAlreadyDefined, "Feature identified by '#{key}' has already been defined"
      end
    end

    def get(key)
      toggle = @toggle_repository.get(key.to_s)
      if toggle.is_a?(Togls::NullToggle)
        Togls.logger.warn("Feature identified by '#{key}' has not been defined")
      end
      toggle
    end

    def all
      @toggle_repository.all
    end
  end
end
