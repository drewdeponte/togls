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
      feature = instance_double(Togls::Feature)
      rule = instance_double(Togls::Rule)
      toggle = instance_double(Togls::Toggle, feature: feature, rule: rule)
      allow(subject.instance_variable_get(:@rule_repository)).to receive(:store)
      expect(subject.instance_variable_get(:@feature_repository)).to receive(:store).with(feature)
      subject.store(toggle)
    end

    it "stores the toggle's rule in the rule repository" do
      allow(driver).to receive(:store)
      feature = instance_double(Togls::Feature)
      rule = instance_double(Togls::Rule)
      toggle = instance_double(Togls::Toggle, feature: feature, rule: rule)
      allow(subject.instance_variable_get(:@feature_repository)).to receive(:store)
      expect(subject.instance_variable_get(:@rule_repository)).to receive(:store).with(rule)
      subject.store(toggle)
    end

    it "iterate over each driver" do
      feature = instance_double(Togls::Feature)
      rule = instance_double(Togls::Rule)
      toggle = instance_double(Togls::Toggle, feature: feature, rule: rule)
      allow(subject.instance_variable_get(:@feature_repository)).to receive(:store)
      allow(subject.instance_variable_get(:@rule_repository)).to receive(:store)
      expect(subject.instance_variable_get(:@drivers)).to receive(:each)
      subject.store(toggle)
    end

    it "store the toggle in each driver" do
      feature = instance_double(Togls::Feature)
      rule = instance_double(Togls::Rule)
      toggle = instance_double(Togls::Toggle, feature: feature, rule: rule)
      allow(subject.instance_variable_get(:@feature_repository)).to receive(:store)
      allow(subject.instance_variable_get(:@rule_repository)).to receive(:store)
      allow(subject.instance_variable_get(:@drivers)).to receive(:each).and_yield(driver)
      expect(driver).to receive(:store).with(toggle)
      subject.store(toggle)
    end
  end
end
