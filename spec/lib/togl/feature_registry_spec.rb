require_relative '../../spec_helper'

describe Togl::FeatureRegistry do
  let(:key) { :key }

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

    it "creates a default false feature" do
      default_feature = double('default_feature').as_null_object
      allow(Togl::Feature).to receive(:new).and_return(default_feature)
      expect(subject.instance_variable_get(:@default_feature)).to eq(default_feature)
    end
  end

  describe "#feature" do
    before do
      allow(Togl::Feature).to receive(:new).with(:default).and_return(spy)
    end

    it "creates a new feature object with the passed key" do
      expect(Togl::Feature).to receive(:new).with(key)
      subject.feature(key)
    end

    it "adds the feature to the registry" do
      feature = double('feature')
      allow(Togl::Feature).to receive(:new).with(key).and_return(feature)
      subject.feature(key)
      expect(subject.instance_variable_get(:@registry)[key]).to eq(feature)
    end
  end

  describe "#get" do
    before do
      allow(Togl::Feature).to receive(:new).with(:default).and_return(spy)
    end

    context "when feature exists in registry" do
      it "returns the feature identified by key" do
        feature = double('feature')
        allow(Togl::Feature).to receive(:new).with(key).and_return(feature)
        subject.feature(key)
        expect(subject.get(key)).to eq(feature)
      end
    end

    context "when feature does not exist in registry" do
      it "logs a warning" do
        expect(Togl.logger).to receive(:warn)
        subject.get(key)
      end

      it "returns the default false feature" do
        allow(Togl.logger).to receive(:warn)
        feature = double('feature')
        subject.instance_variable_set(:@default_feature, feature)
        expect(subject.get(key)).to eq(feature)
      end
    end
  end
end
