require 'spec_helper'

describe Togl::FeatureRegistry do
  describe ".create" do
    it "creates a new instance of a feature registry" do
      registry = double('registry')
      expect(Togl::FeatureRegistry).to receive(:new).and_return(registry)
      b = Proc.new {}
      Togl::FeatureRegistry.create(&b)
    end

    it "calls instance eval with the passed block" do
      feature_registry = double('feature_registry')
      allow(Togl::FeatureRegistry).to receive(:new).and_return(feature_registry)
      b = Proc.new {}
      expect(feature_registry).to receive(:instance_eval).and_yield(&b)
      Togl::FeatureRegistry.create(&b)
    end

    it "returns a configured feature registry object" do
      b = Proc.new {}
      expect(Togl::FeatureRegistry.create(&b)).to be_a(Togl::FeatureRegistry)
    end
  end

  describe "#initalize" do
    it "initalizes registry to an empty hash" do
      expect(subject.instance_variable_get(:@registry)).to eq({})
    end
  end

  describe "#feature" do
    it "creates a new feature object with the passed key" do
      key = :key
      expect(Togl::Feature).to receive(:new).with(key)
      subject.feature(key)
    end

    it "adds the feature to the registry" do
      key = :key
      feature = double('feature')
      allow(Togl::Feature).to receive(:new).and_return(feature)
      subject.feature(key)
      expect(subject.instance_variable_get(:@registry)[key]).to eq(feature)
    end
  end

  describe "#get" do
    it "returns the feature identified by key" do
      key = :key
      feature = double('feature')
      allow(Togl::Feature).to receive(:new).and_return(feature)
      subject.feature(key)
      expect(subject.get(key)).to eq(feature)
    end
  end
end
