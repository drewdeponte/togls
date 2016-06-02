require 'spec_helper'

describe Togls::RuleRepository do
  let(:driver) { double('driver') }
  let(:rule_type_registry) { double('rule_type_registry') }
  subject { Togls::RuleRepository.new(rule_type_registry, [driver]) }

  describe "#initialize" do
    context "when given an array of 1 or more drivers" do
      it "constructs a toggle repository" do
        driver = double('driver')
        repository = Togls::RuleRepository.new(rule_type_registry, [driver])
        expect(repository).to be_a(Togls::RuleRepository)
      end

      it "assigns the given drivers" do
        driver = double('driver')
        repository = Togls::RuleRepository.new(rule_type_registry, [driver])
        expect(repository.instance_variable_get(:@drivers)).to eq([driver])
      end

      it 'assigns the given rule type repository' do
        driver = double('driver')
        rule_type_registry = double('rule type repository')
        repository = Togls::RuleRepository.new(rule_type_registry, [driver])
        expect(repository.instance_variable_get(:@rule_type_registry)).to eq(rule_type_registry)
      end
    end

    context "when given an empty array of drivers" do
      it "raises an exception" do
        expect { Togls::RuleRepository.new(rule_type_registry, []) }.to raise_error(Togls::MissingDriver)
      end
    end

    context "when not given an array" do
      it "raises an exception" do
        expect { Togls::RuleRepository.new(rule_type_registry, "something else") }.to raise_error(Togls::InvalidDriver)
      end
    end
  end

  describe "#store" do
    it "gets the storage payload" do
      rule = Togls::Rule.new
      allow(driver).to receive(:store)
      expect(subject).to receive(:extract_storage_payload).with(rule)
      subject.store(rule)
    end

    it "iterate over each driver" do
      rule = instance_double(Togls::Rule)
      allow(subject).to receive(:extract_storage_payload)
      expect(subject.instance_variable_get(:@drivers)).to receive(:each)
      subject.store(rule)
    end

    it "store the rule data in each driver" do
      rule = Togls::Rule.new(true)
      rule_data = double('rule data')
      allow(subject).to receive(:extract_storage_payload).and_return(rule_data)
      allow(subject.instance_variable_get(:@drivers)).to receive(:each).and_yield(driver)
      expect(driver).to receive(:store).with(rule.id, rule_data)
      subject.store(rule)
    end
  end

  describe "#extract_storage_payload" do
    it 'gets the rule_type_id from rule type repository' do
      rule = Togls::Rule.new(true)
      expect(rule_type_registry).to receive(:get_type_id).with('Togls::Rule')
      subject.extract_storage_payload(rule)
    end

    it 'returns the rule\'s extracted storage payload without the target_type' do
      rule = Togls::Rule.new(true, target_type: :foo)
      allow(rule_type_registry).to receive(:get_type_id).with('Togls::Rule').and_return('hoopty')
      expect(subject.extract_storage_payload(rule))
        .to eq({ 'type_id' => 'hoopty', 'data' => true, 'target_type' => 'foo' })
    end
  end

  describe "#fetch_rule_data" do
    it "reverse the drivers" do
      drivers = subject.instance_variable_get(:@drivers)
      expect(drivers).to receive(:reverse).and_return([])
      subject.fetch_rule_data("some id")
    end

    it "iterate over each driver in reverse order" do
      drivers = subject.instance_variable_get(:@drivers)
      reversed_drivers = double('reversed drivers')
      allow(drivers).to receive(:reverse).and_return(reversed_drivers)
      expect(reversed_drivers).to receive(:each)
      subject.fetch_rule_data("some id")
    end

    it "attempt to get the rule data from each driver" do
      driver = double('driver')
      drivers = subject.instance_variable_get(:@drivers)
      reversed_drivers = double('reversed drivers')
      allow(drivers).to receive(:reverse).and_return(reversed_drivers)
      allow(reversed_drivers).to receive(:each).and_yield(driver)
      expect(driver).to receive(:get).with("some id")
      subject.fetch_rule_data("some id")
    end

    it "short circuits at the first rule it finds" do
      rule_data = double('rule data')
      driver_one = double('driver one')
      driver_two = double('driver two')
      drivers = subject.instance_variable_get(:@drivers)
      reversed_drivers = double('reversed drivers')
      allow(drivers).to receive(:reverse).and_return(reversed_drivers)
      allow(reversed_drivers).to receive(:each).and_yield(driver_one).and_yield(driver_two)
      expect(driver_one).to receive(:get).with("some id").and_return(rule_data)
      expect(driver_two).not_to receive(:get).with("some id")
      subject.fetch_rule_data("some id")
    end

    context "when it finds a rule data" do
      it "returns the first rule data it finds" do
        rule_data = double('rule data')
        driver_one = double('driver one')
        driver_two = double('driver two')
        drivers = subject.instance_variable_get(:@drivers)
        reversed_drivers = double('reversed drivers')
        allow(drivers).to receive(:reverse).and_return(reversed_drivers)
        allow(reversed_drivers).to receive(:each).and_yield(driver_one).and_yield(driver_two)
        allow(driver_one).to receive(:get).with("some id").and_return(rule_data)
        expect(subject.fetch_rule_data("some id")).to eq(rule_data)
      end
    end

    context "when it doesn't find a rule" do
      it "returns nil" do
        rule_data = double('rule data')
        driver_one = double('driver one')
        driver_two = double('driver two')
        drivers = subject.instance_variable_get(:@drivers)
        reversed_drivers = double('reversed drivers')
        allow(drivers).to receive(:reverse).and_return(reversed_drivers)
        allow(reversed_drivers).to receive(:each).and_yield(driver_one).and_yield(driver_two)
        allow(driver_one).to receive(:get).with("some id").and_return(nil)
        allow(driver_two).to receive(:get).with("some id").and_return(nil)
        expect(subject.fetch_rule_data("some id")).to be_nil
      end
    end
  end

  describe "#get" do
    it "get the rule data" do
      expect(subject).to receive(:fetch_rule_data).with("some_id")
      allow(subject).to receive(:reconstitute_rule)
      subject.get("some_id")
    end

    it "reconstitutes a rule" do
      rule_data = double('rule data')
      allow(subject).to receive(:fetch_rule_data).and_return(rule_data)
      expect(subject).to receive(:reconstitute_rule).with(rule_data)
      subject.get("some_id")
    end

    it "returns the rule" do
      rule = double('rule')
      allow(subject).to receive(:fetch_rule_data)
      allow(subject).to receive(:reconstitute_rule).and_return(rule)
      expect(subject.get("some_id")).to eq(rule)
    end
  end

  describe '#reconstitute_rule' do
    it 'constructs a rule from the rule data' do
      allow(rule_type_registry).to receive(:get).with('boolean').and_return(Togls::Rules::Boolean)
      expect(Togls::Rules::Boolean).to receive(:new).with(true)
      subject.reconstitute_rule({ 'type_id' => 'boolean', 'data' => true })
    end

    it 'returns the rule' do
      rule = double('rule')
      allow(rule_type_registry).to receive(:get).with('boolean').and_return(Togls::Rules::Boolean)
      allow(Togls::Rules::Boolean).to receive(:new).with(true).and_return(rule)
      expect(subject.reconstitute_rule({ 'type_id' => 'boolean', 'data' => true })).to eq(rule)
    end
  end
end
