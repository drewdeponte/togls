module Togls
  # Toggle Repository
  #
  # Repository interface for storing and retrieving toggles.
  class ToggleRepository
    def initialize(drivers, feature_repository)
      unless drivers.is_a?(Array)
        raise Togls::InvalidDriver, 'ToggleRepository requires a valid driver'
      end
      if drivers.empty?
        raise Togls::MissingDriver, 'ToggleRepository requires a driver'
      end
      @drivers = drivers
      @feature_repository = feature_repository
    end

    def store(toggle)
      @feature_repository.store(toggle.feature)
      ::Togls.send(:rule_repository).store(toggle.rule)
      payload = extract_storage_payload(toggle)

      @drivers.each do |driver|
        driver.store(toggle.id, payload)
      end
    end

    def extract_storage_payload(toggle)
      { 'feature_id' => toggle.feature.id, 'rule_id' => toggle.rule.id.to_s }
    end

    def get(id)
      @drivers.reverse.each do |driver|
        toggle_data = driver.get(id)
        if toggle_data
          toggle = reconstitute_toggle(toggle_data)
          return toggle unless toggle.is_a?(::Togls::NullToggle)
        end
      end
      Togls::NullToggle.new
    end

    def reconstitute_toggle(toggle_data)
      begin
        feature = @feature_repository.get(toggle_data['feature_id'])
      rescue Togls::RepositoryFeatureDataInvalid => e
        return Togls::NullToggle.new
      end

      begin
        rule = ::Togls.send(:rule_repository).get(toggle_data['rule_id'])
      rescue Togls::RepositoryRuleDataInvalid => e
        return Togls::NullToggle.new
      end

      toggle = Togls::Toggle.new(feature)
      begin
        toggle.rule = rule
        toggle
      rescue Togls::RuleFeatureTargetTypeMismatch
        Togls.logger.warn("Feature (#{feature.key}) with target type '#{feature.target_type}' has a rule (#{rule.id}) mismatch with target type '#{rule.target_type}'")
        return Togls::RuleFeatureMismatchToggle.new
      end
    end
  end
end
