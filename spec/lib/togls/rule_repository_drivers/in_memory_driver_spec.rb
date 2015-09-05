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
    it "gets the storage payload" do
      rule = Togls::Rule.new
      expect(subject).to receive(:extract_storage_payload).with(rule)
      subject.store(rule)
    end

    it "saves the storage payload" do
      rule = Togls::Rule.new
      subject.store(rule)
      expect(subject.instance_variable_get(:@rules)["your_mom"]).to eq({ "key" => "your_mom", "description" => "Your Moms Desc" })
    end
  end

  describe "#extract_storage_payload" do
    it "returns the rule's extracted storage payload" do
      rule = Togls::Rule.new
      expect(subject.extract_storage_payload(rule))
        .to eq({ "key" => "your_mom", "description" => "Your Moms Desc" })
    end
  end
end
