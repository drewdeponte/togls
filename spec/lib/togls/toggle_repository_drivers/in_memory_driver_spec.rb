require 'spec_helper'

describe Togls::ToggleRepositoryDrivers::InMemoryDriver do
  describe "#initialize" do
    it "constructs an instance" do
      res = Togls::ToggleRepositoryDrivers::InMemoryDriver.new
      expect(res).to be_a(Togls::ToggleRepositoryDrivers::InMemoryDriver)
    end

    it "assigns an empty hash for toggles" do
      expect(subject.instance_variable_get(:@toggles)).to eq({})
    end
  end

  describe "#store" do
    it "saves the storage payload" do
      feature = Togls::Feature.new("your_mom", "Your Moms Desc")
      toggle = Togls::Toggle.new(feature)
      toggle_data = double("toggle data")
      subject.store(toggle.id, toggle_data)
      expect(subject.instance_variable_get(:@toggles)[toggle.id])
        .to eq(toggle_data)
    end
  end

  describe "#get" do
    it "return toggle data identified by an id" do
      toggles = subject.instance_variable_get(:@toggles)
      toggles["some_id"] = 'hoopty doopty'
      expect(subject.get("some_id")).to eq('hoopty doopty')
    end
  end

  describe "#all" do
    it "returns the collection of toggles" do
      toggles = subject.instance_variable_get(:@toggles)
      expect(subject.all).to eq(toggles)
    end
  end
end
