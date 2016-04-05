require 'spec_helper'

describe Togls::FeatureToggleRegistryManager do
  let(:klass) { Class.new { include Togls::FeatureToggleRegistryManager } }

  describe ".features" do
    context "when features have NOT been defined" do
      it "creates a new empty feature toggle registry" do
        expect(Togls::FeatureToggleRegistry).to receive(:new)
        klass.features
      end
    end

    context "when given a block" do
      it "expands the feature registry with a new block" do
        registry = klass.features
        b = Proc.new {}
        expect(registry).to receive(:expand).and_yield(&b)
        klass.features(&b)
      end
    end

    it "returns the feature toggle registry" do
      feature_toggle_registry = double('feature toggle registry')
      allow(Togls::FeatureToggleRegistry).to receive(:new).and_return(feature_toggle_registry)
      expect(klass.features).to eq(feature_toggle_registry)
    end
  end

  describe ".feature" do
    context "when features have NOT been defined" do
      it "creates a new empty feature toggle registry" do
        klass.instance_variable_set(:@feature_toggle_registry, nil)
        expect(Togls::FeatureToggleRegistry).to receive(:new).and_call_original
        klass.feature("key")
      end
    end

    it "returns the feature toggle identified by the key" do
      feature_registry = instance_double Togls::FeatureToggleRegistry 
      klass.instance_variable_set(:@feature_toggle_registry, feature_registry)
      expect(feature_registry).to receive(:get).with("key")
      klass.feature("key")
    end
  end

  describe ".logger" do
    it "memoizes a new logger instance" do
      logger = double('logger')
      klass.instance_variable_set(:@logger, nil)
      allow(Logger).to receive(:new).with(STDOUT).and_return(logger)
      expect(klass.logger).to eq(logger)
      expect(klass.logger).to eq(logger)
    end
  end

  describe '.enable_test_mode' do
    it 'stores the current feature toggle registry' do
      test_registry = double('test registry')
      klass.instance_variable_set(:@feature_toggle_registry, test_registry)
      klass.enable_test_mode
      expect(klass.instance_variable_get(:@previous_feature_toggle_registry)).to\
        eq(test_registry)
    end

    it 'sets the feature toggle registry to the test toggle registry' do
      test_registry = double('test registry')
      allow(klass).to receive(:test_toggle_registry).and_return(test_registry)
      klass.enable_test_mode
      expect(klass.instance_variable_get(:@feature_toggle_registry)).to eq(test_registry)
    end
  end

  describe '.disable_test_mode' do
    it 'restores the feature toggle registry to prev stored value' do
      test_registry = double('test registry')
      klass.instance_variable_set(:@previous_feature_toggle_registry, test_registry)
      klass.disable_test_mode
      expect(klass.instance_variable_get(:@feature_toggle_registry)).to\
        eq(test_registry)
    end
  end
end
