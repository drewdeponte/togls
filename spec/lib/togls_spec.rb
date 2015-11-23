require_relative '../spec_helper'

describe Togls do
  describe ".features" do
    context "when features have NOT been defined" do
      it "creates a new empty feature toggle registry" do
        expect(Togls::FeatureToggleRegistry).to receive(:new)
        Togls.features
      end
    end

    context "when given a block" do
      it "expands the feature registry with a new block" do
        registry = Togls.features
        b = Proc.new {}
        expect(registry).to receive(:expand).and_yield(&b)
        Togls.features(&b)
      end
    end

    it "returns the feature toggle registry" do
      feature_toggle_registry = double('feature toggle registry')
      allow(Togls::FeatureToggleRegistry).to receive(:new).and_return(feature_toggle_registry)
      expect(Togls.features).to eq(feature_toggle_registry)
    end
  end

  describe ".features=" do
    it "assigns the given feature toggle registry to @feature_toggle_registry" do
      feature_toggle_registry = double('feature toggle registry')
      Togls.features = feature_toggle_registry
      expect(Togls.features).to eq(feature_toggle_registry)
    end
  end

  describe ".feature" do
    it "returns the feature toggle identified by the key" do
      feature_registry = instance_double Togls::FeatureToggleRegistry 
      Togls.instance_variable_set(:@feature_toggle_registry, feature_registry)
      expect(feature_registry).to receive(:get).with("key")
      Togls.feature("key")
    end
  end

  describe ".logger" do
    it "memoizes a new logger instance" do
      logger = double('logger')
      Togls.instance_variable_set(:@logger, nil)
      allow(Logger).to receive(:new).with(STDOUT).and_return(logger)
      expect(Togls.logger).to eq(logger)
      expect(Togls.logger).to eq(logger)
    end
  end
end
