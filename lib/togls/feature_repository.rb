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
      feature_data = extract_feature_data(feature)
      @drivers.each do |driver|
        driver.store(feature.id, feature_data)
      end
    end

    def extract_feature_data(feature)
      { "key" => feature.key, "description" => feature.description }
    end

    def fetch_feature_data(id)
      feature_data = nil
      @drivers.reverse.each do |driver|
        feature_data = driver.get(id)
        break if feature_data
      end
      feature_data
    end

    def get(feature_id)
      feature_data = fetch_feature_data(feature_id)
      reconstitute_feature(feature_data)
    end

    def reconstitute_feature(feature_data)
      Togls::Feature.new(feature_data["key"],
                         feature_data["description"])
    end
  end
end
