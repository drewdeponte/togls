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

  describe "storing and retrieving" do
    it "saves and retrieves the storage payload" do
      feature = Togls::Feature.new("some_feature_key", "Some Feature Desc", :foo)
      subject.store(feature.id, { "key" => feature.key, "description" => feature.description })
      expect(subject.get(feature.id)).to eq({ "key" => feature.key, "description" => feature.description })
    end

    context 'when attempting to retrieve a non stored value' do
      it 'returns nil' do
        expect(subject.get('non_existent_key')).to be_nil
      end
    end
  end
end
