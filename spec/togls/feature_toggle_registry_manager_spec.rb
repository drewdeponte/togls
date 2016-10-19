require 'spec_helper'

RSpec.describe Togls::FeatureToggleRegistryManager do
  let(:klass) { Class.new { include Togls::FeatureToggleRegistryManager } }

  describe ".release" do
    context "when features have NOT been defined" do
      it "creates a new empty release toggle registry" do
        expect(Togls::ToggleRegistry).to receive(:new)
        klass.release
      end
    end

    context "when given a block" do
      it "expands the feature registry with a new block" do
        registry = klass.release
        b = Proc.new {}
        expect(registry).to receive(:expand).and_yield(&b)
        klass.release(&b)
      end
    end

    it "returns the release toggle registry" do
      release_toggle_registry = double('release toggle registry')
      allow(Togls::ToggleRegistry).to receive(:new).and_return(release_toggle_registry)
      expect(klass.release).to eq(release_toggle_registry)
    end
  end

  describe '.feature' do
    context "when features have NOT been defined" do
      it "creates a new empty release toggle registry" do
        klass.instance_variable_set(:@release_toggle_registry, nil)
        expect(Togls::ToggleRegistry).to receive(:new).and_call_original
        klass.feature("key")
      end
    end

    it "returns the release toggle identified by the key" do
      feature_registry = instance_double Togls::ToggleRegistry 
      klass.instance_variable_set(:@release_toggle_registry, feature_registry)
      expect(feature_registry).to receive(:get).with("key")
      klass.feature("key")
    end
  end

  describe '.enable_test_mode' do
    it 'stores the current release toggle registry' do
      test_registry = double('test registry')
      klass.instance_variable_set(:@release_toggle_registry, test_registry)
      klass.enable_test_mode
      expect(klass.instance_variable_get(:@previous_release_toggle_registry)).to\
        eq(test_registry)
    end

    it 'sets the release toggle registry to the test toggle registry' do
      test_registry = double('test registry')
      allow(klass).to receive(:test_toggle_registry).and_return(test_registry)
      klass.enable_test_mode
      expect(klass.instance_variable_get(:@release_toggle_registry)).to eq(test_registry)
    end
  end

  describe '.disable_test_mode' do
    it 'restores the release toggle registry to prev stored value' do
      test_registry = double('test registry')
      klass.instance_variable_set(:@previous_release_toggle_registry, test_registry)
      klass.disable_test_mode
      expect(klass.instance_variable_get(:@release_toggle_registry)).to\
        eq(test_registry)
    end
  end

  describe '.test_mode' do
    it 'enables test mode' do
      allow(klass).to receive(:disable_test_mode)
      expect(klass).to receive(:enable_test_mode)
      klass.test_mode {}
    end

    it 'yields the provided block' do
      allow(klass).to receive(:enable_test_mode)
      allow(klass).to receive(:disable_test_mode)
      expect { |b| klass.test_mode(&b) }.to yield_control
    end

    it 'disables test mode' do
      allow(klass).to receive(:enable_test_mode)
      expect(klass).to receive(:disable_test_mode)
      klass.test_mode {}
    end
  end
end
