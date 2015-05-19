require_relative '../../spec_helper'

describe Togls::FeatureRegistry do
  let(:key) { :key }

  describe "#initalize" do
    it "initalizes registry to an empty hash" do
      expect(subject.instance_variable_get(:@registry)).to eq({})
    end

    it "creates a default false feature" do
      default_feature = double('default_feature').as_null_object
      allow(Togls::Feature).to receive(:new).and_return(default_feature)
      expect(subject.instance_variable_get(:@default_feature)).to eq(default_feature)
    end
  end

  describe ".create" do
    it "creates a new instance of a feature registry" do
      registry = double('registry')
      expect(Togls::FeatureRegistry).to receive(:new).and_return(registry)
      b = Proc.new {}
      Togls::FeatureRegistry.create(&b)
    end

    it "calls instance eval with the passed block" do
      feature_registry = double('feature_registry')
      allow(Togls::FeatureRegistry).to receive(:new).and_return(feature_registry)
      b = Proc.new {}
      expect(feature_registry).to receive(:instance_eval).and_yield(&b)
      Togls::FeatureRegistry.create(&b)
    end

    it "returns a configured feature registry object" do
      b = Proc.new {}
      expect(Togls::FeatureRegistry.create(&b)).to be_a(Togls::FeatureRegistry)
    end
  end


  describe "#feature" do
    before do
      allow(Togls::Feature).to receive(:new).with(:default, "the official default feature").and_return(spy)
    end

    it "creates a new feature object with the passed key" do
      desc = double('feature desc')
      expect(Togls::Feature).to receive(:new).with(key, desc)
      subject.feature(key, desc)
    end

    it "adds the feature to the registry" do
      desc = double('feature desc')
      feature = double('feature')
      allow(Togls::Feature).to receive(:new).with(key, desc).and_return(feature)
      subject.feature(key, desc)
      expect(subject.instance_variable_get(:@registry)[key]).to eq(feature)
    end
  end

  describe "#get" do
    before do
      allow(Togls::Feature).to receive(:new).with(:default, "the official default feature").and_return(spy)
    end

    context "when feature exists in registry" do
      it "returns the feature identified by key" do
        desc = double('feature desc')
        feature = double('feature')
        allow(Togls::Feature).to receive(:new).with(key, desc).and_return(feature)
        subject.feature(key, desc)
        expect(subject.get(key)).to eq(feature)
      end
    end

    context "when feature does not exist in registry" do
      it "logs a warning" do
        expect(Togls.logger).to receive(:warn)
        subject.get(key)
      end

      it "returns the default false feature" do
        allow(Togls.logger).to receive(:warn)
        feature = double('feature')
        subject.instance_variable_set(:@default_feature, feature)
        expect(subject.get(key)).to eq(feature)
      end
    end
  end

  describe "#registry" do
    it "returns the registry of feature objects" do
      feature_double = double('feature')
      feature_registry = Togls::FeatureRegistry.create do
      end
      feature_registry.instance_variable_set(:@registry, { :test => feature_double })
      expect(feature_registry.registry).to eq({ :test => feature_double })
    end
  end
end
