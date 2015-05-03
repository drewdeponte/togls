require_relative '../spec_helper'

describe Togl do
  describe ".features" do
    it "creates a new feature registry with passed block" do
      b = Proc.new {}
      expect(Togl::FeatureRegistry).to receive(:create).and_yield(&b)
      Togl.features(&b)
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

  describe ".logger" do
    it "memoizes a new logger instance" do
      logger = double('logger')
      Togl.instance_variable_set(:@logger, nil)
      allow(Logger).to receive(:new).with(STDOUT).and_return(logger)
      expect(Togl.logger).to eq(logger)
      expect(Togl.logger).to eq(logger)
    end
  end
end
