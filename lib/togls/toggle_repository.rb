module Togls
  class ToggleRepository
    def initialize(drivers, feature_repository, rule_repository)
      if !drivers.is_a?(Array)
        raise Togls::InvalidDriver.new("ToggleRepository requires a valid driver")
      end
      if drivers.empty?
        raise Togls::MissingDriver.new("ToggleRepository requires a driver")
      end
      @drivers = drivers
      @feature_repository = feature_repository
      @rule_repository = rule_repository
    end

    def store(toggle)
      @feature_repository.store(toggle.feature)
      @rule_repository.store(toggle.rule)
      payload = extract_storage_payload(toggle)

      @drivers.each do |driver|
        driver.store(toggle.id, payload)
      end
    end

    def extract_storage_payload(toggle)
      { "feature_id" => toggle.feature.id, "rule_id" => toggle.rule.id }
    end

    def get(id)
      toggle_data = fetch_toggle_data(id)
      if toggle_data
        return reconstitute_toggle(toggle_data)
      else
        return Togls::NullToggle.new
      end
    end

    def reconstitute_toggle(toggle_data)
      feature = @feature_repository.get(toggle_data["feature_id"])
      rule = @rule_repository.get(toggle_data["rule_id"])
      toggle = Togls::Toggle.new(feature, Togls::Rules::Boolean)
      toggle.rule = rule
      return toggle
    end

    def fetch_toggle_data(id)
      toggle_data = nil
      @drivers.reverse.each do |driver|
        toggle_data = driver.get(id)
        break if toggle_data
      end
      toggle_data
    end

    def fetch_all_toggle_data
      toggle_data_collection = {}
      @drivers.each do |driver|
        toggle_data_collection.merge!(driver.all)
      end
      toggle_data_collection
    end

    def all
      toggle_data_collection = fetch_all_toggle_data.values

      toggle_data_collection.map do |toggle_data|
        reconstitute_toggle(toggle_data)
      end
    end
  end
end
