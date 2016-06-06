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
      if feature_data.nil?
        Togls.logger.debug("None of the feature repository drivers claim to have the feature")
        raise Togls::RepositoryFeatureDataInvalid, "None of the feature repository drivers claim to have the feature"
      end

      ['key', 'description', 'target_type'].each do |k|
        if !feature_data.has_key? k
          Togls.logger.debug("One of the feature repository drivers returned feature data that is missing the '#{k}'")
          raise Togls::RepositoryFeatureDataInvalid, "One of the feature repository drivers returned feature data that is missing the '#{k}'"
        end

        if !feature_data[k].is_a?(String)
          Togls.logger.debug("One of the feature repository drivers returned feature data with '#{k}' not being a string")
          raise Togls::RepositoryFeatureDataInvalid, "One of the feature repository drivers returned feature data with '#{k}' not being a string"
        end
      end
    end
  end
end
