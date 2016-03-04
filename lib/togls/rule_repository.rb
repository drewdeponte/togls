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
        driver.store(rule.id, rule_data)
      end
    end

    def extract_storage_payload(rule)
      { 'klass' => rule.class, 'data' => rule.data }
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
      rule_data['klass'].new(rule_data['data'])
    end
  end
end
