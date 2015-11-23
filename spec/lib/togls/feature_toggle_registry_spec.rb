require 'spec_helper'

describe Togls::FeatureToggleRegistry do
  subject { Togls::FeatureToggleRegistry.new }

  describe "#initalize" do
    it "constructs the ToggleRepository InMemoryDriver" do
      expect(Togls::ToggleRepositoryDrivers::InMemoryDriver).to receive(:new)
      subject
    end

    it "constructs the ToggleRepository EnvOverrideDriver" do
      expect(Togls::ToggleRepositoryDrivers::EnvOverrideDriver).to receive(:new)
      subject
    end

    it "assigns the toggle repository drivers" do
      driver_one = double('driver in memory')
      driver_two = double('driver env override')
      allow(Togls::ToggleRepositoryDrivers::InMemoryDriver).to receive(:new).and_return(driver_one)
      allow(Togls::ToggleRepositoryDrivers::EnvOverrideDriver).to receive(:new).and_return(driver_two)
      expect(subject.instance_variable_get(:@toggle_repository_drivers)).to eq([driver_one, driver_two])
    end

    it "constructs the FeatureRepository InMemoryDriver" do
      expect(Togls::FeatureRepositoryDrivers::InMemoryDriver).to receive(:new)
      subject
    end

    it "assigns the feature repository drivers" do
      driver = double('driver')
      allow(Togls::RuleRepository).to receive(:new).and_return(double.as_null_object)
      allow(Togls::FeatureRepositoryDrivers::InMemoryDriver).to receive(:new).and_return(driver)
      expect(subject.instance_variable_get(:@feature_repository_drivers)).to eq([driver])
    end

    it "constructs the RuleRepository InMemoryDriver" do
      allow(Togls::RuleRepository).to receive(:new).and_return(double.as_null_object)
      expect(Togls::RuleRepositoryDrivers::InMemoryDriver).to receive(:new)
      subject
    end

    it "assigns the rule repository drivers" do
      driver_one = double('in memory driver')
      driver_two = double('env driver')
      allow(Togls::RuleRepository).to receive(:new).and_return(double.as_null_object)
      allow(Togls::RuleRepositoryDrivers::InMemoryDriver).to receive(:new).and_return(driver_one)
      expect(subject.instance_variable_get(:@rule_repository_drivers)).to eq([driver_one])
    end

    it "constructs a feature repository" do
      allow(Togls::FeatureRepository).to receive(:new)
      driver = double('driver')
      allow(Togls::FeatureRepositoryDrivers::InMemoryDriver).to receive(:new).and_return(driver)
      subject
      expect(Togls::FeatureRepository).to have_received(:new).with([driver])
    end

    it "assigns the constructed feature repository" do
      feature_repository = double('feature repository')
      allow(Togls::FeatureRepository).to receive(:new).and_return(feature_repository)
      expect(subject.instance_variable_get(:@feature_repository)).to eq(feature_repository)
    end

    it "constructs a rule repository" do
      allow(Togls::RuleRepository).to receive(:new).and_return(double.as_null_object)
      driver_one = double('driver in memory')
      driver_two = double('driver env')
      allow(Togls::RuleRepositoryDrivers::InMemoryDriver).to receive(:new).and_return(driver_one)
      subject
      expect(Togls::RuleRepository).to have_received(:new).with([driver_one])
    end

    it "assigns the constructed rule repository" do
      rule_repository = double('rule repository').as_null_object
      allow(Togls::RuleRepository).to receive(:new).and_return(rule_repository)
      expect(subject.instance_variable_get(:@rule_repository)).to eq(rule_repository)
    end

    it "constructs a toggle repository" do
      allow(Togls::ToggleRepository).to receive(:new)
      feature_repository = double('feature repository')
      allow(Togls::FeatureRepository).to receive(:new).and_return(feature_repository)
      rule_repository = double('rule repository').as_null_object
      allow(Togls::RuleRepository).to receive(:new).and_return(rule_repository)
      driver_one = double('driver in memory')
      driver_two = double('driver env override')
      allow(Togls::ToggleRepositoryDrivers::InMemoryDriver).to receive(:new).and_return(driver_one)
      allow(Togls::ToggleRepositoryDrivers::EnvOverrideDriver).to receive(:new).and_return(driver_two)
      subject
      expect(Togls::ToggleRepository).to have_received(:new).with([driver_one, driver_two], feature_repository, rule_repository)
    end

    it "assigns the constructed toggle repository" do
      toggle_repository = double('toggle repository')
      allow(Togls::ToggleRepository).to receive(:new).and_return(toggle_repository)
      allow(Togls::RuleRepository).to receive(:new).and_return(double.as_null_object)
      expect(subject.instance_variable_get(:@toggle_repository)).to eq(toggle_repository)
    end

    it "constructs boolean true rule" do
      expect(Togls::Rules::Boolean).to receive(:new).with(true)
      allow(Togls::Rules::Boolean).to receive(:new).with(false)
      allow(Togls::RuleRepository).to receive(:new).and_return(double.as_null_object)
      subject
    end

    it "assigns the boolean true rule" do
      boolean_true_rule = double('boolean true rule')
      allow(Togls::Rules::Boolean).to receive(:new).with(false)
      allow(Togls::RuleRepository).to receive(:new).and_return(double.as_null_object)
      allow(Togls::Rules::Boolean).to receive(:new).with(true).and_return(boolean_true_rule)
      expect(subject.instance_variable_get(:@boolean_true_rule)).to eq(boolean_true_rule)
    end

    it "constructs boolean false rule" do
      allow(Togls::Rules::Boolean).to receive(:new).with(true)
      allow(Togls::RuleRepository).to receive(:new).and_return(double.as_null_object)
      expect(Togls::Rules::Boolean).to receive(:new).with(false)
      subject
    end

    it "assigns the boolean false rule" do
      boolean_false_rule = double('boolean true rule')
      allow(Togls::Rules::Boolean).to receive(:new).with(true)
      allow(Togls::Rules::Boolean).to receive(:new).with(false).and_return(boolean_false_rule)
      allow(Togls::RuleRepository).to receive(:new).and_return(double.as_null_object)
      expect(subject.instance_variable_get(:@boolean_false_rule)).to eq(boolean_false_rule)
    end

    it "stores the boolean false rule" do
      boolean_false_rule = double('boolean false rule')
      boolean_true_rule = double('boolean true rule')
      rule_repository = double('rule repository')
      allow(Togls::RuleRepository).to receive(:new).and_return(rule_repository)
      allow(Togls::Rules::Boolean).to receive(:new).with(false).and_return(boolean_false_rule)
      allow(Togls::Rules::Boolean).to receive(:new).with(true).and_return(boolean_true_rule)
      allow(rule_repository).to receive(:store).with(boolean_true_rule)
      expect(rule_repository).to receive(:store).with(boolean_false_rule)
      subject
    end

    it "stores the boolean true rule" do
      boolean_false_rule = double('boolean false rule')
      boolean_true_rule = double('boolean true rule')
      rule_repository = double('rule repository')
      allow(Togls::RuleRepository).to receive(:new).and_return(rule_repository)
      allow(Togls::Rules::Boolean).to receive(:new).with(false).and_return(boolean_false_rule)
      allow(Togls::Rules::Boolean).to receive(:new).with(true).and_return(boolean_true_rule)
      allow(rule_repository).to receive(:store).with(boolean_false_rule)
      expect(rule_repository).to receive(:store).with(boolean_true_rule)
      subject
    end
  end

  describe ".create" do
    it "creates a new instance of a feature toggle registry" do
      registry = double('registry')
      expect(Togls::FeatureToggleRegistry).to receive(:new).and_return(registry)
      b = Proc.new {}
      Togls::FeatureToggleRegistry.create(&b)
    end

    context "when block given" do
      it "calls instance eval with the passed block" do
        registry = double('registry')
        allow(Togls::FeatureToggleRegistry).to receive(:new).and_return(registry)
        b = Proc.new {}
        expect(registry).to receive(:instance_eval).and_yield(&b)
        Togls::FeatureToggleRegistry.create(&b)
      end
    end

    it "returns a configured feature registry object" do
      b = Proc.new {}
      expect(Togls::FeatureToggleRegistry.create(&b)).to be_a(Togls::FeatureToggleRegistry)
    end
  end

  describe "#expand" do
    it "instance evals the provided block" do
      registry = Togls::FeatureToggleRegistry.create do
        feature(:foo, "some description").on
      end

      expect(registry).to receive(:instance_eval)
      registry.expand do
        feature(:bar, "some other desc").on
      end
    end

    it "returns the feature toggle repository" do
      registry = Togls::FeatureToggleRegistry.create do
        feature(:foo, "some description").on
      end

      block = Proc.new {}
      expect(registry.expand(&block)).to eq(registry)
    end
  end

  describe "#feature" do
    it "creates a new feature object with the passed key" do
      desc = double('feature desc')
      key = "some_key"
      feature = Togls::Feature.new('your_mom', "Your Moms Desc")
      expect(Togls::Feature).to receive(:new).with(key, desc).and_return(feature)
      subject.feature(key, desc)
    end
    
    it "creates a feature toggle with the created feature" do
      desc = double('feature desc')
      key = "some_key"
      feature = double(Togls::Feature)
      allow(Togls::Feature).to receive(:new).and_return(feature)
      expect(Togls::Toggle).to receive(:new).with(feature).and_return(double.as_null_object)
      subject.feature(key, desc)
    end

    it "store the toggle" do
      toggle = double('toggle')
      toggle_repository = subject.instance_variable_get(:@toggle_repository)
      desc = double('feature desc')
      key = "some_key"
      allow(Togls::Feature).to receive(:new)
      allow(Togls::Toggle).to receive(:new).and_return(toggle)
      expect(toggle_repository).to receive(:store).with(toggle)
      subject.feature(key, desc)
    end

    it "constructs a toggler" do
      key = "some_key"
      desc = double('feature desc')
      toggle_repository = subject.instance_variable_get(:@toggle_repository)
      toggle = double('toggle')
      allow(toggle_repository).to receive(:store)
      allow(Togls::Toggle).to receive(:new).and_return(toggle)
      expect(Togls::Toggler).to receive(:new).with(toggle_repository, toggle)
      subject.feature(key, desc)
    end

    it "returns the created toggler" do
      key = "some_key"
      desc = double('feature desc')
      toggle = double('toggle').as_null_object
      toggler = double('toggler')
      allow(Togls::Toggle).to receive(:new).and_return(toggle)
      allow(Togls::Toggler).to receive(:new).and_return(toggler)
      expect(subject.feature(key, desc)).to eq(toggler)
    end
  end

  describe "#get" do
    it "attempts to fetch the toggle from the toggle repository" do
      toggle_repository = subject.instance_variable_get(:@toggle_repository)
      expect(toggle_repository).to receive(:get).with("some key")
      subject.get("some key")
    end

    context "when the toggle is found" do
      it "returns the obtained feature toggle" do
        toggle = double('toggle')
        toggle_repository = subject.instance_variable_get(:@toggle_repository)
        allow(toggle_repository).to receive(:get).and_return(toggle)
        expect(subject.get("some key")).to eq(toggle)
      end
    end

    context "when the toggle is NOT found" do
      before do
        null_toggle = Togls::NullToggle.new
        toggle_repository = subject.instance_variable_get(:@toggle_repository)
        allow(toggle_repository).to receive(:get).and_return(null_toggle)
      end

      it "logs a warning" do
        expect(Togls.logger).to receive(:warn).with("Feature identified by 'some_id' has not been defined")
        subject.get("some_id")
      end

      it "returns a null toggle" do
        expect(subject.get("some not real key")).to be_a(Togls::NullToggle)
      end
    end
  end

  describe "#all" do
    it "fetches all toggles" do
      toggle_repository = subject.instance_variable_get(:@toggle_repository)
      expect(toggle_repository).to receive(:all)
      subject.all
    end
  end
end
