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
      { 'key' => feature.key, 'description' => feature.description, 'target_type' => feature.target_type.to_s }
    end

    def fetch_feature_data(id)
      feature_data = nil
      @drivers.reverse.each do |driver|
        feature_data = driver.get(id)
        break if feature_data
      end
      feature_data
    end

    def include?(feature_id)
      result = fetch_feature_data(feature_id)
      result.nil? ? false : true
    end

    def get(feature_id)
      feature_data = fetch_feature_data(feature_id)
      validate_feature_data(feature_data)
      reconstitute_feature(feature_data)
    end

    def reconstitute_feature(feature_data)
      Togls::Feature.new(feature_data['key'],
                         feature_data['description'],
                         feature_data['target_type'].to_sym)
    end

    def validate_feature_data(feature_data)
      raise Togls::RepositoryFeatureDataInvalid, "None of the feature repository drivers claim to have the feature" if feature_data.nil?
      keys = ['key', 'description', 'target_type'].each do |k|
        raise Togls::RepositoryFeatureDataInvalid, "One of the feature repository drivers returned feature data that is missing the '#{k}'" unless feature_data.has_key? k
        raise Togls::RepositoryFeatureDataInvalid, "One of the feature repository drivers returned feature data with '#{k}' not being a string" unless feature_data[k].is_a?(String)
      end
    end
  end
end
