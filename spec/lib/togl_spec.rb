require 'spec_helper'

describe Togl do
  describe ".features" do
    it "creates a new feature registry with passed block" do
      b = Proc.new {}
      expect(Togl::FeatureRegistry).to receive(:create).and_yield(&b)
      Togl.features(&b)
    end
  end

  describe "feature creation" do
    it "creates a new feature toggled on" do
      Togl.features do
        feature(:test).on
      end

      expect(Togl.feature(:test).on?).to eq(true)
    end
  end

  describe ".feature" do
    it "returns the feature identified by the key" do
      feature = double('feature')
      feature_registry = Togl::FeatureRegistry.new
      feature_registry.instance_variable_set(:@registry, {key: feature})
      allow(feature_registry).to receive(:get).with(:key).and_return(feature)
      Togl.instance_variable_set(:@feature_registry, feature_registry)
      expect(Togl.feature(:key)).to eq(feature)
    end
  end
end
