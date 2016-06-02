require 'spec_helper'

describe Togls::ToggleRepository do
  let(:driver) { double('driver') }
  let(:rule_repository) { double('rule repository') }
  let(:feature_repository) { double('feature repository') }

  subject { Togls::ToggleRepository.new([driver], feature_repository, rule_repository) }

  describe "#initialize" do
    context "when given an array of 1 or more drivers" do
      it "constructs a toggle repository" do
        repository = Togls::ToggleRepository.new([driver],
                                                 feature_repository,
                                                 rule_repository)
        expect(repository).to be_a(Togls::ToggleRepository)
      end

      it "assigns the given drivers" do
        repository = Togls::ToggleRepository.new([driver],
                                                 feature_repository,
                                                 rule_repository)
        expect(repository.instance_variable_get(:@drivers)).to eq([driver])
      end

      it "assigns the feature repository" do
        repository = Togls::ToggleRepository.new([driver],
                                                 feature_repository,
                                                 rule_repository)
        expect(repository.instance_variable_get(:@feature_repository)).to eq(feature_repository)
      end

      it "assigns the rule repository" do
        repository = Togls::ToggleRepository.new([driver],
                                                 feature_repository,
                                                 rule_repository)
        expect(repository.instance_variable_get(:@rule_repository)).to eq(rule_repository)
      end
    end

    context "when given an empty array of drivers" do
      it "raises an exception" do
        expect { Togls::ToggleRepository.new([], feature_repository,
                                             rule_repository) }.to raise_error(Togls::MissingDriver)
      end
    end

    context "when not given an array" do
      it "raises an exception" do
        expect { Togls::ToggleRepository.new("something else",
                                             feature_repository,
                                             rule_repository) }.to raise_error(Togls::InvalidDriver)
      end
    end
  end

  describe "#store" do
    it "stores the toggle's feature in the feature repository" do
      allow(driver).to receive(:store)
      feature = instance_double(Togls::Feature, id: 'foueououeo')
      rule = instance_double(Togls::Rule, id: '234oau234oue')
      toggle = instance_double(Togls::Toggle, feature: feature, rule: rule, id: 'foueououeo')
      allow(subject.instance_variable_get(:@rule_repository)).to receive(:store)
      expect(subject.instance_variable_get(:@feature_repository)).to receive(:store).with(feature)
      subject.store(toggle)
    end

    it "stores the toggle's rule in the rule repository" do
      allow(driver).to receive(:store)
      feature = instance_double(Togls::Feature, id: 'foueououeo')
      rule = instance_double(Togls::Rule, id: '234oau234oue')
      toggle = instance_double(Togls::Toggle, feature: feature, rule: rule, id: 'foueououeo')
      allow(subject.instance_variable_get(:@feature_repository)).to receive(:store)
      expect(subject.instance_variable_get(:@rule_repository)).to receive(:store).with(rule)
      subject.store(toggle)
    end

    it "gets the storage payload" do
      feature = Togls::Feature.new("some_feature_key", "Some Feature Desc")
      toggle = Togls::Toggle.new(feature)
      allow(subject.instance_variable_get(:@feature_repository)).to receive(:store)
      allow(subject.instance_variable_get(:@rule_repository)).to receive(:store)
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
      allow(subject.instance_variable_get(:@rule_repository)).to receive(:store)
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
      allow(subject.instance_variable_get(:@rule_repository)).to receive(:store)
      allow(subject.instance_variable_get(:@drivers)).to receive(:each).and_yield(driver)
      expect(driver).to receive(:store).with(toggle.id, toggle_data)
      subject.store(toggle)
    end
  end

  describe "#extract_storage_payload" do
    it "returns the feature's extracted storage payload" do
      feature = Togls::Feature.new("some_feature_key", "Some Feature Desc")
      toggle = Togls::Toggle.new(feature)
      expect(subject.extract_storage_payload(toggle))
        .to eq({ "feature_id" => "some_feature_key", "rule_id" => "4e4b466b49e148b5a58de1d666ca7c87c7765301" })
    end
  end

  describe "#get" do
    it "attempts to fetch toggle data" do
      expect(subject).to receive(:fetch_toggle_data).with("some id")
      subject.get("some id")
    end

    context "when the toggle data is found" do
      before do
        @toggle_data = double('toggle data')
        allow(subject).to receive(:fetch_toggle_data).and_return(@toggle_data)
      end

      it "reconstitutes a toggle from toggle data" do
        expect(subject).to receive(:reconstitute_toggle).with(@toggle_data)
        subject.get("some_id")
      end

      it "returns the reconstituted toggle" do
        toggle = double('toggle')
        allow(subject).to receive(:reconstitute_toggle).and_return(toggle)
        subject.get("some id")
      end
    end

    context "when the toggle data is NOT found" do
      before do
        allow(subject).to receive(:fetch_toggle_data).and_return(nil)
      end

      it "constructs a null toggle" do
        expect(Togls::ToggleMissingToggle).to receive(:new)
        subject.get("some id")
      end

      it "returns the null toggle" do
        null_toggle = double('null toggle')
        allow(Togls::ToggleMissingToggle).to receive(:new).and_return(null_toggle)
        expect(subject.get("some id")).to eq(null_toggle)
      end
    end
  end

  describe "#reconstitute_toggle" do
    it "fetches the referenced feature from the feature repository" do
      toggle_data = { "feature_id" => "badges", "rule_id" => "ba234aoeubaooea23" }
      toggle = double('toggle')
      allow(rule_repository).to receive(:get)
      allow(Togls::Toggle).to receive(:new).and_return(toggle)
      allow(toggle).to receive(:rule=)
      expect(feature_repository).to receive(:get).with("badges")
      subject.reconstitute_toggle(toggle_data)
    end

    it "fetches the referenced rule from the rule repository" do
      toggle_data = { "feature_id" => "badges", "rule_id" => "ba234aoeubaooea23" }
      toggle = double('toggle')
      allow(feature_repository).to receive(:get)
      allow(Togls::Toggle).to receive(:new).and_return(toggle)
      allow(toggle).to receive(:rule=)
      expect(rule_repository).to receive(:get).with("ba234aoeubaooea23")
      subject.reconstitute_toggle(toggle_data)
    end

    it "constructs a toggle with the fetcthed feature" do
      toggle_data = { "feature_id" => "badges", "rule_id" => "ba234aoeubaooea23" }
      feature = double('feature')
      allow(rule_repository).to receive(:get)
      allow(feature_repository).to receive(:get).and_return(feature)
      expect(Togls::Toggle).to receive(:new).with(feature).and_return(double.as_null_object)
      subject.reconstitute_toggle(toggle_data)
    end

    it "its associates the fetched ruled with the toggle" do
      toggle_data = { "feature_id" => "badges", "rule_id" => "ba234aoeubaooea23" }
      toggle = double('toggle')
      rule = double('rule')
      allow(rule_repository).to receive(:get).and_return(rule)
      allow(feature_repository).to receive(:get)
      allow(Togls::Toggle).to receive(:new).and_return(toggle)
      expect(toggle).to receive(:rule=).with(rule)
      subject.reconstitute_toggle(toggle_data)
    end

    context 'when rule assignment identifies a miss match' do
      it 'returns a constructed missmatch toggle' do
        toggle_data = { "feature_id" => "badges", "rule_id" => "ba234aoeubaooea23" }
        rule = double 'rule'
        toggle = double('toggle')
        null_toggle = double 'null toggle'
        allow(feature_repository).to receive(:get)
        allow(rule_repository).to receive(:get).and_return(rule)
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
        allow(rule_repository).to receive(:get).and_return(rule)
        allow(feature_repository).to receive(:get)
        allow(Togls::Toggle).to receive(:new).and_return(toggle)
        allow(toggle).to receive(:rule=).with(rule)
        expect(subject.reconstitute_toggle(toggle_data)).to eq(toggle)
      end
    end
  end

  describe "#fetch_toggle_data" do
    it "reverse the drivers" do
      drivers = subject.instance_variable_get(:@drivers)
      expect(drivers).to receive(:reverse).and_return([])
      subject.fetch_toggle_data("some id")
    end

    it "iterate over each driver in reverse order" do
      drivers = subject.instance_variable_get(:@drivers)
      reversed_drivers = double('reversed drivers')
      allow(drivers).to receive(:reverse).and_return(reversed_drivers)
      expect(reversed_drivers).to receive(:each)
      subject.fetch_toggle_data("some id")
    end

    it "attempt to get the toggle data from each driver" do
      driver = double('driver')
      drivers = subject.instance_variable_get(:@drivers)
      reversed_drivers = double('reversed drivers')
      allow(drivers).to receive(:reverse).and_return(reversed_drivers)
      allow(reversed_drivers).to receive(:each).and_yield(driver)
      expect(driver).to receive(:get).with("some id")
      subject.fetch_toggle_data("some id")
    end

    it "short circuits at the first toggle it finds" do
      toggle_data = double('toggle data')
      driver_one = double('driver one')
      driver_two = double('driver two')
      drivers = subject.instance_variable_get(:@drivers)
      reversed_drivers = double('reversed drivers')
      allow(drivers).to receive(:reverse).and_return(reversed_drivers)
      allow(reversed_drivers).to receive(:each).and_yield(driver_one).and_yield(driver_two)
      expect(driver_one).to receive(:get).with("some id").and_return(toggle_data)
      expect(driver_two).not_to receive(:get).with("some id")
      subject.fetch_toggle_data("some id")
    end

    context "when it finds a toggle data" do
      it "returns the first toggle data it finds" do
        toggle_data = double('toggle data')
        driver_one = double('driver one')
        driver_two = double('driver two')
        drivers = subject.instance_variable_get(:@drivers)
        reversed_drivers = double('reversed drivers')
        allow(drivers).to receive(:reverse).and_return(reversed_drivers)
        allow(reversed_drivers).to receive(:each).and_yield(driver_one).and_yield(driver_two)
        allow(driver_one).to receive(:get).with("some id").and_return(toggle_data)
        expect(subject.fetch_toggle_data("some id")).to eq(toggle_data)
      end
    end

    context "when it doesn't find a toggle" do
      it "returns nil" do
        toggle_data = double('toggle data')
        driver_one = double('driver one')
        driver_two = double('driver two')
        drivers = subject.instance_variable_get(:@drivers)
        reversed_drivers = double('reversed drivers')
        allow(drivers).to receive(:reverse).and_return(reversed_drivers)
        allow(reversed_drivers).to receive(:each).and_yield(driver_one).and_yield(driver_two)
        allow(driver_one).to receive(:get).with("some id").and_return(nil)
        allow(driver_two).to receive(:get).with("some id").and_return(nil)
        expect(subject.fetch_toggle_data("some id")).to be_nil
      end
    end
  end

  describe "#fetch_all_toggle_data" do
    it "iterate over each driver in order" do
      drivers = subject.instance_variable_get(:@drivers)
      expect(drivers).to receive(:each)
      subject.fetch_all_toggle_data
    end

    it "attempt to get the toggle data from each driver" do
      driver = double('driver')
      drivers = subject.instance_variable_get(:@drivers)
      allow(drivers).to receive(:each).and_yield(driver)
      expect(driver).to receive(:all).and_return({})
      subject.fetch_all_toggle_data
    end

    it "return a merged hash of all toggle data from all drivers" do
      driver_one = double('driver one', all: { "foo" => "bar", "jack" => "black" })
      driver_two = double('driver two', all: { "hoopty" => "doopty", "foo" => "car" })
      drivers = subject.instance_variable_get(:@drivers)
      allow(drivers).to receive(:each).and_yield(driver_one).and_yield(driver_two)
      expect(subject.fetch_all_toggle_data).to eq({ "jack" => "black", "hoopty" => "doopty", "foo" => "car" })
    end
  end

  describe "#all" do
    it "fetches all toggle data" do
      expect(subject).to receive(:fetch_all_toggle_data).and_return({})
      subject.all
    end

    it "maps over all the toggle data entries" do
      toggle_data_collection = double('toggle data entries')
      toggle_data_collection_hash = double('toggle data entries', values: toggle_data_collection)
      allow(subject).to receive(:fetch_all_toggle_data).and_return(toggle_data_collection_hash)
      expect(toggle_data_collection).to receive(:map)
      subject.all
    end

    it "reconstitutes each toggle" do
      toggle_data = double('toggle data')
      toggle_data_collection = double('toggle data entries')
      toggle_data_collection_hash = double('toggle data entries', values: toggle_data_collection)
      allow(subject).to receive(:fetch_all_toggle_data).and_return(toggle_data_collection_hash)
      allow(toggle_data_collection).to receive(:map).and_yield(toggle_data)
      expect(subject).to receive(:reconstitute_toggle).with(toggle_data)
      subject.all
    end

    it "returns all the toggles" do
      toggle = double('toggle')
      toggle_data = double('toggle data')
      toggle_data_collection = double('toggle data entries')
      toggle_data_collection_hash = {
        "badges" => { "feature_id" => "badges", "rule_id" => "aeuuaoeuoau23432" },
        "login" => { "feature_id" => "login", "rule_id" => "213a124323a" }
      }
      allow(subject).to receive(:fetch_all_toggle_data).and_return(toggle_data_collection_hash)
      allow(toggle_data_collection).to receive(:map).and_yield(toggle_data)
      allow(subject).to receive(:reconstitute_toggle).and_return(toggle)
      expect(subject.all.length).to eq(2)
    end
  end
end
