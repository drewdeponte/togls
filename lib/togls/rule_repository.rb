module Togls
  # Rule Repository
  #
  # The Rule Repository is the intended interface to store and retrieve rules.
  # It does these by interfacing with Rule Repository Drivers which are passed
  # in during construction as an Array.
  class RuleRepository
    def initialize(drivers)
      unless drivers.is_a?(Array)
        raise Togls::InvalidDriver, 'RuleRepository requires a valid driver'
      end
      if drivers.empty?
        raise Togls::MissingDriver, 'RuleRepository requires a driver'
      end
      @drivers = drivers
    end

    def store(rule)
      rule_data = extract_storage_payload(rule)
      @drivers.each do |driver|
        driver.store(rule.id.to_s, rule_data)
      end
    end

    def extract_storage_payload(rule)
      {
        'id' => rule.id.to_s,
        'type_id' => ::Togls.send(:rule_type_registry).get_type_id(rule.class.to_s),
        'data' => rule.data,
        'target_type' => rule.target_type.to_s
      }
    end

    def fetch_rule_data(id)
      rule_data = nil
      @drivers.reverse.each do |driver|
        rule_data = driver.get(id)
        break if rule_data
      end
      rule_data
    end

    def get(rule_id)
      rule_data = fetch_rule_data(rule_id)
      validate_rule_data(rule_data)
      reconstitute_rule(rule_data)
    end

    def validate_rule_data(rule_data)
      if rule_data.nil?
        Togls.logger.warn "None of the rule repository drivers claim to have the rule"
        raise Togls::RepositoryRuleDataInvalid, "None of the rule repository drivers claim to have the rule"
      end

      ['id', 'type_id', 'data', 'target_type'].each do |k|
        if !rule_data.has_key? k
          Togls.logger.warn "One of the rule repository drivers returned rule data that is missing the '#{k}'"
          raise Togls::RepositoryRuleDataInvalid, "One of the rule repository drivers returned rule data that is missing the '#{k}'"
        end
      end

      ['id', 'type_id', 'target_type'].each do |k|
        if !rule_data[k].is_a?(String)
          Togls.logger.warn "One of the rule repository drivers returned rule data with '#{k}' not being a string"
          raise Togls::RepositoryRuleDataInvalid, "One of the rule repository drivers returned rule data with '#{k}' not being a string"
        end
      end
    end

    def reconstitute_rule(rule_data)
      if rule_data.has_key?('target_type')
        ::Togls.rule_type(rule_data['type_id'])\
          .new(rule_data['id'].to_sym, rule_data['type_id'].to_sym, rule_data['data'],
               target_type: rule_data['target_type'].to_sym)
      else
        ::Togls.rule_type(rule_data['type_id']).new(rule_data['id'].to_sym,
                                                    rule_data['type_id'].to_sym,
                                                    rule_data['data'])
      end
    end
  end
end
