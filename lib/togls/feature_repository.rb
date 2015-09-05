module Togls
  class FeatureRepository
    def initialize(drivers)
      if !drivers.is_a?(Array)
        raise Togls::InvalidDriver.new("FeatureRepository requires a valid driver")
      end
      if drivers.empty?
        raise Togls::MissingDriver.new("FeatureRepository requires a driver")
      end
      @drivers = drivers
    end

    def store(feature)
      @drivers.each do |driver|
        driver.store(feature)
      end
    end
  end
end
