require 'spec_helper'

describe Togls::FeatureToggleRegistry do
  let(:base_rule_type_klass) { Togls::Rules::Boolean }
  subject { Togls::FeatureToggleRegistry.new(base_rule_type_klass) }

  describe "#initalize" do
    it "initalizes registry to an empty hash" do
      expect(subject.instance_variable_get(:@registry)).to eq({})
    end

    it "stores the base rule type klass" do
      base_rule_type_klass = double("rule_type_klass")
      feature_reg = Togls::FeatureToggleRegistry.new(base_rule_type_klass)
      expect(feature_reg.instance_variable_get(:@base_rule_type_klass)).to eq(base_rule_type_klass)
    end
  end

  describe ".create" do
    it "creates a new instance of a feature toggle registry" do
      registry = double('registry')
      expect(Togls::FeatureToggleRegistry).to receive(:new).and_return(registry)
      b = Proc.new {}
      Togls::FeatureToggleRegistry.create(double, &b)
    end

    it "calls instance eval with the passed block" do
      registry = double('registry')
      allow(Togls::FeatureToggleRegistry).to receive(:new).and_return(registry)
      b = Proc.new {}
      expect(registry).to receive(:instance_eval).and_yield(&b)
      Togls::FeatureToggleRegistry.create(double, &b)
    end

    it "returns a configured feature registry object" do
      b = Proc.new {}
      expect(Togls::FeatureToggleRegistry.create(Togls::Rules::Boolean, &b)).to be_a(Togls::FeatureToggleRegistry)
    end
  end

  describe "#feature" do
    it "creates a new feature object with the passed key" do
      desc = double('feature desc')
      key = "some_key"
      expect(Togls::Feature).to receive(:new).with(key, desc)
      subject.feature(key, desc)
    end
    
    it "creates a feature toggle with the created feature" do
      desc = double('feature desc')
      key = "some_key"
      feature = double Togls::Feature
      allow(Togls::Feature).to receive(:new).and_return(feature)
      expect(Togls::Toggle).to receive(:new).with(feature, base_rule_type_klass)
      subject.feature(key, desc)
    end
    
    it "adds the created toggle to the registry" do
      desc = double('feature desc')
      feature = double('feature')
      toggle = double('toggle')
      key = "some_key"
      allow(Togls::Feature).to receive(:new).with(key, desc).and_return(feature)
      allow(Togls::Toggle).to receive(:new).and_return(toggle)
      subject.feature(key, desc)
      expect(subject.instance_variable_get(:@registry)[key]).to eq(toggle)
    end
  end

  describe "#default_toggle" do
    it "creates a default feature" do
      key = "default"
      desc = "the offical Togls default feature"
      expect(Togls::Feature).to receive(:new).with(key, desc)
      subject.default_toggle
    end

    it "creates a toggle with the default feature" do
      feature = instance_double Togls::Feature
      allow(Togls::Feature).to receive(:new).and_return(feature)
      expect(Togls::Toggle).to receive(:new).with(feature, base_rule_type_klass)
        .and_return(double.as_null_object)
      subject.default_toggle
    end

    context "when called more than once" do
      it "returns the memoized toggle" do
        result = subject.default_toggle
        expect(subject.default_toggle).to eq(result)
      end
    end
  end

  describe "#registry" do
    it "returns the registry of feature objects" do
      feature_toggle = double('feature toggle')
      feature_registry = Togls::FeatureToggleRegistry.create(Togls::Rules::Boolean) do
      end
      feature_registry.instance_variable_set(:@registry, { :test => feature_toggle })
      expect(feature_registry.registry).to eq({ :test => feature_toggle })
    end
  end

  describe "#get" do
    context "when feature toggle exists in registry" do
      it "returns the feature toggle identified by key" do
        desc = double('feature desc')
        key = "key"
        toggle = instance_double Togls::Toggle
        allow(Togls::Toggle).to receive(:new).and_return(toggle)
        subject.feature(key, desc)
        expect(subject.get(key)).to eq(toggle)
      end
    end

    context "when feature does not exist in registry" do
      it "logs a warning" do
        key = "key"
        expect(Togls.logger).to receive(:warn)
        subject.get(key)
      end

      it "returns the default false feature toggle" do
        key = "key"
        default_feature_toggle = instance_double Togls::Toggle
        allow(subject).to receive(:default_toggle).and_return(default_feature_toggle)
        expect(subject.get(key)).to eq(default_feature_toggle)
      end
    end
  end
end
