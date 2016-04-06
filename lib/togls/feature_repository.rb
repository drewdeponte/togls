module Togls
  # Feature Repository
  #
  # The Feature Repository is the primary interface for storing and retrieving
  # feature entities using the initialized prioritized drivers Array.
  class FeatureRepository
    def initialize(drivers)
      unless drivers.is_a?(Array)
        raise Togls::InvalidDriver, 'FeatureRepository requires a valid driver'
      end
      if drivers.empty?
        raise Togls::MissingDriver, 'FeatureRepository requires a driver'
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
      { 'key' => feature.key, 'description' => feature.description }
    end

    def fetch_feature_data(id)
      feature_data = nil
      @drivers.reverse.each do |driver|
        feature_data = driver.get(id)
        break if feature_data
      end
      feature_data
    end

    def exist?(feature_id)
      result = fetch_feature_data(feature_id)
      result.nil? ? false : true
    end

    def get(feature_id)
      feature_data = fetch_feature_data(feature_id)
      reconstitute_feature(feature_data)
    end

    def reconstitute_feature(feature_data)
      Togls::Feature.new(feature_data['key'],
                         feature_data['description'])
    end
  end
end
