module Togls
  class RuleRepository
    def initialize(drivers)
      if !drivers.is_a?(Array)
        raise Togls::InvalidDriver.new("FeatureRepository requires a valid driver")
      end
      if drivers.empty?
        raise Togls::MissingDriver.new("FeatureRepository requires a driver")
      end
      @drivers = drivers
    end

    def store(rule)
      @drivers.each do |driver|
        driver.store(rule)
      end
    end
  end
end
