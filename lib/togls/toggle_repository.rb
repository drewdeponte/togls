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

      @drivers.each do |driver|
        driver.store(toggle)
      end
    end
  end
end
