require 'spec_helper'

RSpec.describe Togls::ToggleRepository do
  let(:driver) { double('driver') }
  let(:feature_repository) { double('feature repository') }

  subject { Togls::ToggleRepository.new([driver], feature_repository) }

  describe "#initialize" do
    context "when given an array of 1 or more drivers" do
      it "constructs a toggle repository" do
        repository = Togls::ToggleRepository.new([driver],
                                                 feature_repository)
        expect(repository).to be_a(Togls::ToggleRepository)
      end

      it "assigns the given drivers" do
        repository = Togls::ToggleRepository.new([driver],
                                                 feature_repository)
        expect(repository.instance_variable_get(:@drivers)).to eq([driver])
      end

      it "assigns the feature repository" do
        repository = Togls::ToggleRepository.new([driver],
                                                 feature_repository)
        expect(repository.instance_variable_get(:@feature_repository)).to eq(feature_repository)
      end
    end

    context "when given an empty array of drivers" do
      it "raises an exception" do
        expect { Togls::ToggleRepository.new([], feature_repository) }.to raise_error(Togls::MissingDriver)
      end
    end

    context "when not given an array" do
      it "raises an exception" do
        expect { Togls::ToggleRepository.new("something else",
                                             feature_repository) }.to raise_error(Togls::InvalidDriver)
      end
    end
  end

  describe "#store" do
    it "stores the toggle's feature in the feature repository" do
      allow(driver).to receive(:store)
      feature = instance_double(Togls::Feature, id: 'foueououeo')
      rule = instance_double(Togls::Rule, id: '234oau234oue')
      toggle = instance_double(Togls::Toggle, feature: feature, rule: rule, id: 'foueououeo')
      allow(::Togls.send(:rule_repository)).to receive(:store)
      expect(subject.instance_variable_get(:@feature_repository)).to receive(:store).with(feature)
      subject.store(toggle)
    end

    it "stores the toggle's rule in the rule repository" do
      allow(driver).to receive(:store)
      feature = instance_double(Togls::Feature, id: 'foueououeo')
      rule = instance_double(Togls::Rule, id: '234oau234oue')
      toggle = instance_double(Togls::Toggle, feature: feature, rule: rule, id: 'foueououeo')
      allow(subject.instance_variable_get(:@feature_repository)).to receive(:store)
      expect(::Togls.send(:rule_repository)).to receive(:store).with(rule)
      subject.store(toggle)
    end

    it "gets the storage payload" do
      feature = Togls::Feature.new("some_feature_key", "Some Feature Desc", :hoopty)
      toggle = Togls::Toggle.new(feature)
      allow(subject.instance_variable_get(:@feature_repository)).to receive(:store)
      allow(::Togls.send(:rule_repository)).to receive(:store)
      allow(driver).to receive(:store)
      expect(subject).to receive(:extract_storage_payload).with(toggle)
      subject.store(toggle)
    end

    it "iterate over each driver" do
      feature = instance_double(Togls::Feature)
      rule = instance_double(Togls::Rule)
      toggle = instance_double(Togls::Toggle, feature: feature, rule: rule)
      allow(subject).to receive(:extract_storage_payload)
      allow(subject.instance_variable_get(:@feature_repository)).to receive(:store)
      allow(::Togls.send(:rule_repository)).to receive(:store)
      expect(subject.instance_variable_get(:@drivers)).to receive(:each)
      subject.store(toggle)
    end

    it "store the toggle data in each driver" do
      feature = instance_double(Togls::Feature)
      rule = instance_double(Togls::Rule)
      toggle = instance_double(Togls::Toggle, feature: feature, rule:
                               rule, id: 'faeouaouoe')
      toggle_data = double('toggle data')
      allow(subject).to receive(:extract_storage_payload).and_return(toggle_data)
      allow(subject.instance_variable_get(:@feature_repository)).to receive(:store)
      allow(::Togls.send(:rule_repository)).to receive(:store)
      allow(subject.instance_variable_get(:@drivers)).to receive(:each).and_yield(driver)
      expect(driver).to receive(:store).with(toggle.id, toggle_data)
      subject.store(toggle)
    end
  end

  describe "#extract_storage_payload" do
    it "returns the feature's extracted storage payload" do
      feature = Togls::Feature.new("some_feature_key", "Some Feature Desc", :hoopty)
      toggle = Togls::Toggle.new(feature)
      expect(subject.extract_storage_payload(toggle))
        .to eq({ "feature_id" => "some_feature_key", "rule_id" => "off" })
    end
  end

  describe "#get" do
    it "reverse the drivers" do
      drivers = subject.instance_variable_get(:@drivers)
      expect(drivers).to receive(:reverse).and_return([])
      subject.get("some id")
    end

    it "iterate over each driver in reverse order" do
      drivers = subject.instance_variable_get(:@drivers)
      reversed_drivers = double('reversed drivers')
      allow(drivers).to receive(:reverse).and_return(reversed_drivers)
      expect(reversed_drivers).to receive(:each)
      subject.get("some id")
    end

    it "attempt to get the toggle data from each driver" do
      driver = double('driver')
      drivers = subject.instance_variable_get(:@drivers)
      reversed_drivers = double('reversed drivers')
      allow(drivers).to receive(:reverse).and_return(reversed_drivers)
      allow(reversed_drivers).to receive(:each).and_yield(driver)
      expect(driver).to receive(:get).with("some id")
      subject.get("some id")
    end

    context 'when toggle data found' do
      it 'attempts to reconstitute the toggle' do
        toggle_data = double('toggle data')
        driver_one = double('driver one')
        driver_two = double('driver two')
        drivers = subject.instance_variable_get(:@drivers)
        reversed_drivers = double('reversed drivers')
        allow(drivers).to receive(:reverse).and_return(reversed_drivers)
        allow(reversed_drivers).to receive(:each).and_yield(driver_one).and_yield(driver_two)
        allow(driver_one).to receive(:get).with("some id").and_return(toggle_data)
        expect(driver_two).not_to receive(:get).with("some id")
        expect(subject).to receive(:reconstitute_toggle).with(toggle_data)
        subject.get("some id")
      end

      context 'when successfully reconstitutes the toggle' do
        it 'returns the toggle' do
          toggle = double('toggle')
          toggle_data = double('toggle data')
          driver_one = double('driver one')
          driver_two = double('driver two')
          drivers = subject.instance_variable_get(:@drivers)
          reversed_drivers = double('reversed drivers')
          allow(drivers).to receive(:reverse).and_return(reversed_drivers)
          allow(reversed_drivers).to receive(:each).and_yield(driver_one).and_yield(driver_two)
          allow(driver_one).to receive(:get).with("some id").and_return(toggle_data)
          expect(driver_two).not_to receive(:get).with("some id")
          allow(subject).to receive(:reconstitute_toggle).with(toggle_data).and_return(toggle)
          expect(subject.get("some id")).to eq(toggle)
        end
      end

      context 'when fails to reconstitute the toggle' do
        it 'falls through to the next driver' do
          toggle_data = double('toggle data')
          driver_one = double('driver one')
          driver_two = double('driver two')
          drivers = subject.instance_variable_get(:@drivers)
          reversed_drivers = double('reversed drivers')
          allow(drivers).to receive(:reverse).and_return(reversed_drivers)
          allow(reversed_drivers).to receive(:each).and_yield(driver_one).and_yield(driver_two)
          allow(driver_one).to receive(:get).with("some id").and_return(toggle_data)
          allow(subject).to receive(:reconstitute_toggle).with(toggle_data).and_return(::Togls::NullToggle.new)
          expect(driver_two).to receive(:get).with("some id")
          subject.get("some id")
        end
      end

      context 'when has exhausted all drivers and still has not found a toggle' do
        it 'returns the null toggle' do
          toggle_data = double('toggle data')
          driver_one = double('driver one')
          driver_two = double('driver two')
          drivers = subject.instance_variable_get(:@drivers)
          reversed_drivers = double('reversed drivers')
          allow(drivers).to receive(:reverse).and_return(reversed_drivers)
          allow(reversed_drivers).to receive(:each).and_yield(driver_one).and_yield(driver_two)
          allow(driver_one).to receive(:get).with("some id").and_return(toggle_data)
          allow(subject).to receive(:reconstitute_toggle).with(toggle_data).and_return(::Togls::NullToggle.new)
          allow(driver_two).to receive(:get).with("some id")
          expect(subject.get("some id")).to be_a(::Togls::NullToggle)
        end
      end
    end

    context 'when toggle data not found' do
      it 'falls through to the next driver' do
        toggle_data = double('toggle data')
        driver_one = double('driver one')
        driver_two = double('driver two')
        drivers = subject.instance_variable_get(:@drivers)
        reversed_drivers = double('reversed drivers')
        allow(drivers).to receive(:reverse).and_return(reversed_drivers)
        allow(reversed_drivers).to receive(:each).and_yield(driver_one).and_yield(driver_two)
        allow(driver_one).to receive(:get).with("some id")
        expect(driver_two).to receive(:get).with("some id")
        subject.get("some id")
      end
    end
  end

  describe "#reconstitute_toggle" do
    it "fetches the referenced feature from the feature repository" do
      toggle_data = { "feature_id" => "badges", "rule_id" => "ba234aoeubaooea23" }
      toggle = double('toggle')
      allow(::Togls.send(:rule_repository)).to receive(:get)
      allow(Togls::Toggle).to receive(:new).and_return(toggle)
      allow(toggle).to receive(:rule=)
      expect(feature_repository).to receive(:get).with("badges")
      subject.reconstitute_toggle(toggle_data)
    end

    context 'when fails to fetch a feature' do
      it 'short circuits and returns a null toggle' do
        toggle_data = { "feature_id" => "badges", "rule_id" => "ba234aoeubaooea23" }
        allow(Togls.logger).to receive(:warn)
        allow(feature_repository).to receive(:get).and_raise(Togls::RepositoryFeatureDataInvalid)
        expect(subject.reconstitute_toggle(toggle_data)).to be_a(Togls::NullToggle)
      end
    end

    it "fetches the referenced rule from the rule repository" do
      toggle_data = { "feature_id" => "badges", "rule_id" => "ba234aoeubaooea23" }
      toggle = double('toggle')
      allow(feature_repository).to receive(:get)
      allow(Togls::Toggle).to receive(:new).and_return(toggle)
      allow(toggle).to receive(:rule=)
      expect(::Togls.send(:rule_repository)).to receive(:get).with("ba234aoeubaooea23")
      subject.reconstitute_toggle(toggle_data)
    end

    context 'when fails to fetch a rule' do
      it 'short circuits and returns a null toggle' do
        toggle_data = { "feature_id" => "badges", "rule_id" => "ba234aoeubaooea23" }
        allow(feature_repository).to receive(:get)
        allow(Togls.logger).to receive(:warn)
        allow(::Togls.send(:rule_repository)).to receive(:get).and_raise(Togls::RepositoryRuleDataInvalid)
        expect(subject.reconstitute_toggle(toggle_data)).to be_a(Togls::NullToggle)
      end
    end

    it "constructs a toggle with the fetcthed feature" do
      toggle_data = { "feature_id" => "badges", "rule_id" => "ba234aoeubaooea23" }
      feature = double('feature')
      allow(::Togls.send(:rule_repository)).to receive(:get)
      allow(feature_repository).to receive(:get).and_return(feature)
      expect(Togls::Toggle).to receive(:new).with(feature).and_return(double.as_null_object)
      subject.reconstitute_toggle(toggle_data)
    end

    it "its associates the fetched ruled with the toggle" do
      toggle_data = { "feature_id" => "badges", "rule_id" => "ba234aoeubaooea23" }
      toggle = double('toggle')
      rule = double('rule')
      allow(::Togls.send(:rule_repository)).to receive(:get).and_return(rule)
      allow(feature_repository).to receive(:get)
      allow(Togls::Toggle).to receive(:new).and_return(toggle)
      expect(toggle).to receive(:rule=).with(rule)
      subject.reconstitute_toggle(toggle_data)
    end

    context 'when rule assignment identifies a mismatch' do
      it 'logs the mismatch' do
        toggle_data = { "feature_id" => "badges", "rule_id" => "ba234aoeubaooea23" }
        rule = double('rule', id: 'someid', target_type: 'janky')
        feature = double('feature', key: 'feature_key', target_type: 'hoopty')
        toggle = double('toggle')
        null_toggle = double 'null toggle'
        allow(feature_repository).to receive(:get).and_return(feature)
        allow(::Togls.send(:rule_repository)).to receive(:get).and_return(rule)
        allow(Togls::Toggle).to receive(:new).and_return(toggle)
        allow(toggle).to receive(:rule=).and_raise Togls::RuleFeatureTargetTypeMismatch
        allow(Togls::RuleFeatureMismatchToggle).to receive(:new).and_return(null_toggle)
        expect(Togls.logger).to receive(:warn).with("Feature (feature_key) with target type 'hoopty' has a rule (someid) mismatch with target type 'janky'")
        subject.reconstitute_toggle(toggle_data)
      end

      it 'returns a constructed mismatch toggle' do
        toggle_data = { "feature_id" => "badges", "rule_id" => "ba234aoeubaooea23" }
        rule = double('rule', id: 'someid', target_type: 'janky')
        toggle = double('toggle')
        feature = double('feature', key: 'feature_key', target_type: 'hoopty')
        null_toggle = double 'null toggle'
        allow(feature_repository).to receive(:get).and_return(feature)
        allow(::Togls.send(:rule_repository)).to receive(:get).and_return(rule)
        allow(Togls::Toggle).to receive(:new).and_return(toggle)
        allow(toggle).to receive(:rule=).and_raise Togls::RuleFeatureTargetTypeMismatch
        allow(Togls::RuleFeatureMismatchToggle).to receive(:new).and_return(null_toggle)
        result = subject.reconstitute_toggle(toggle_data)
        expect(result).to eql null_toggle
      end
    end

    context 'when rule assignment is successful' do
      it "returns the toggle" do
        toggle_data = { "feature_id" => "badges", "rule_id" => "ba234aoeubaooea23" }
        toggle = double('toggle')
        rule = double('rule')
        allow(::Togls.send(:rule_repository)).to receive(:get).and_return(rule)
        allow(feature_repository).to receive(:get)
        allow(Togls::Toggle).to receive(:new).and_return(toggle)
        allow(toggle).to receive(:rule=).with(rule)
        expect(subject.reconstitute_toggle(toggle_data)).to eq(toggle)
      end
    end
  end
end
