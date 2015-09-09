require 'spec_helper'

describe Togls::RuleRepositoryDrivers::InMemoryDriver do
  describe "#initialize" do
    it "constructs an instance" do
      res = Togls::RuleRepositoryDrivers::InMemoryDriver.new
      expect(res).to be_a(Togls::RuleRepositoryDrivers::InMemoryDriver)
    end

    it "assigns an empty hash for rules" do
      expect(subject.instance_variable_get(:@rules)).to eq({})
    end
  end

  describe "#store" do
    it "saves the storage payload" do
      subject.store('aeuaoeuoa2342eau', { "klass" => Togls::Rule, "data" => true })
      expect(subject.instance_variable_get(:@rules)['aeuaoeuoa2342eau']).to eq({ "klass" => Togls::Rule, "data" => true })
    end
  end

  describe "#get" do
    it "return rule data identified by an id" do
      rules = subject.instance_variable_get(:@rules)
      rules["some_id"] = 'hoopty doopty'
      expect(subject.get("some_id")).to eq('hoopty doopty')
    end
  end
end
