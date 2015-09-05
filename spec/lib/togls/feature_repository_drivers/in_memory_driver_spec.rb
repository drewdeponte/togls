require 'spec_helper'

describe Togls::FeatureRepositoryDrivers::InMemoryDriver do
  describe "#initialize" do
    it "constructs an instance" do
      res = Togls::FeatureRepositoryDrivers::InMemoryDriver.new
      expect(res).to be_a(Togls::FeatureRepositoryDrivers::InMemoryDriver)
    end

    it "assigns an empty hash for features" do
      expect(subject.instance_variable_get(:@features)).to eq({})
    end
  end

  describe "#store" do
    it "gets the storage payload" do
      feature = Togls::Feature.new("your_mom", "Your Moms Desc")
      expect(subject).to receive(:extract_storage_payload).with(feature)
      subject.store(feature)
    end

    it "saves the storage payload" do
      feature = Togls::Feature.new("your_mom", "Your Moms Desc")
      subject.store(feature)
      expect(subject.instance_variable_get(:@features)["your_mom"]).to eq({ "key" => "your_mom", "description" => "Your Moms Desc" })
    end
  end

  describe "#extract_storage_payload" do
    it "returns the feature's extracted storage payload" do
      feature = Togls::Feature.new("your_mom", "Your Moms Desc")
      expect(subject.extract_storage_payload(feature))
        .to eq({ "key" => "your_mom", "description" => "Your Moms Desc" })
    end
  end
end
