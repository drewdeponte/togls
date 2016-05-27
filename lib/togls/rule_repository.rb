module Togls
  # Rule Repository
  #
  # The Rule Repository is the intended interface to store and retrieve rules.
  # It does these by interfacing with Rule Repository Drivers which are passed
  # in during construction as an Array.
  class RuleRepository
    def initialize(rule_type_registry, drivers)
      unless drivers.is_a?(Array)
        raise Togls::InvalidDriver, 'RuleRepository requires a valid driver'
      end
      if drivers.empty?
        raise Togls::MissingDriver, 'RuleRepository requires a driver'
      end
      @drivers = drivers
      @rule_type_registry = rule_type_registry
    end

    def store(rule)
      rule_data = extract_storage_payload(rule)
      @drivers.each do |driver|
        driver.store(rule.id, rule_data)
      end
    end

    def extract_storage_payload(rule)
      { 'type_id' => @rule_type_registry.get_type_id(rule.class.to_s), 'data' => rule.data }
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
      reconstitute_rule(rule_data)
    end

    def reconstitute_rule(rule_data)
      @rule_type_registry.get(rule_data['type_id']).new(rule_data['data'])
    end
  end
end
