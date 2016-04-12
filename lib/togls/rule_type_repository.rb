module Togls
  class RuleTypeRepository
    def initialize(drivers)
      @drivers = drivers
    end

    def store(type_id, klass)
      @drivers.each do |driver|
        driver.store(type_id.to_s, klass.to_s)
      end
    end

    def get_klass(type_id)
      klass_string = fetch_klass_string(type_id.to_s)
      return Object.const_get(klass_string) if klass_string
      klass_string
    end

    def get_type_id(klass)
      fetch_type_id(klass.to_s)
    end

    private

    def reverse_drivers(&block)
      val = nil
      @drivers.reverse.each do |driver|
        val = block.call(driver) if block_given?
        break if val
      end
      val
    end

    def fetch_klass_string(type_id)
      reverse_drivers do |driver|
        driver.get_klass(type_id)
      end
    end

    def fetch_type_id(klass_str)
      reverse_drivers do |driver|
        driver.get_type_id(klass_str)
      end
    end
  end
end
