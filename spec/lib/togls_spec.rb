require_relative '../spec_helper'

describe Togls do
  describe ".features" do
    it "creates a new feature registry with passed block" do
      b = Proc.new {}
      expect(Togls::FeatureRegistry).to receive(:create).and_yield(&b)
      Togls.features(&b)
    end
  end

  describe ".feature" do
    it "returns the feature identified by the key" do
      feature = double('feature')
      feature_registry = Togls::FeatureRegistry.new
      feature_registry.instance_variable_set(:@registry, {key: feature})
      allow(feature_registry).to receive(:get).with(:key).and_return(feature)
      Togls.instance_variable_set(:@feature_registry, feature_registry)
      expect(Togls.feature(:key)).to eq(feature)
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
