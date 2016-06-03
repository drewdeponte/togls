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

  describe "storing and retrieving" do
    it "saves the storage payload and retrieves it" do
      feature = Togls::Feature.new("some_feature_key", "Some Feature Desc", :hoopty)
      toggle = Togls::Toggle.new(feature)
      toggle_data = { 'feature_id' => toggle.feature.id, 'rule_id' => toggle.rule.id }
      subject.store(toggle.id, toggle_data)
      expect(subject.get(toggle.id)).to eq({ 'feature_id' => toggle.feature.id, 'rule_id' => toggle.rule.id })
    end

    context 'when attempting to retrieve a non stored value' do
      it 'returns nil' do
        expect(subject.get('non_existent_key')).to be_nil
      end
    end
  end

  describe "#all" do
    it "returns the collection of toggles" do
      feature = Togls::Feature.new("some_feature_key", "Some Feature Desc", :hoopty)
      toggle = Togls::Toggle.new(feature)
      toggle_data = { 'feature_id' => toggle.feature.id, 'rule_id' => toggle.rule.id }
      subject.store(toggle.id, toggle_data)
      expect(subject.all).to eq({"some_feature_key"=>{"feature_id"=>toggle.feature.id, "rule_id"=>toggle.rule.id}})
    end
  end
end
