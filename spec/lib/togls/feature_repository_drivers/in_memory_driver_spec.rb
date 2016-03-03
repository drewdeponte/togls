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
    it "saves the storage payload" do
      feature = Togls::Feature.new("some_feature_key", "Some Feature Desc")
      subject.store(feature.id, { "key" => "some_feature_key", "description" => "Some Feature Desc" })
      expect(subject.instance_variable_get(:@features)["some_feature_key"]).to eq({ "key" => "some_feature_key", "description" => "Some Feature Desc" })
    end
  end

  describe "#get" do
    it "return feature data identified by an id" do
      features = subject.instance_variable_get(:@features)
      features["some_id"] = 'hoopty doopty'
      expect(subject.get("some_id")).to eq('hoopty doopty')
    end
  end
end
