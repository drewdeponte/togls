require 'spec_helper'

RSpec.describe Togls::FeatureRepository do
  let(:driver) { double('driver') }
  subject { Togls::FeatureRepository.new([driver]) }

  describe "#initialize" do
    context "when given an array of 1 or more drivers" do
      it "constructs a toggle repository" do
        driver = double('driver')
        repository = Togls::FeatureRepository.new([driver])
        expect(repository).to be_a(Togls::FeatureRepository)
      end

      it "assigns the given drivers" do
        driver = double('driver')
        repository = Togls::FeatureRepository.new([driver])
        expect(repository.instance_variable_get(:@drivers)).to eq([driver])
      end
    end

    context "when given an empty array of drivers" do
      it "raises an exception" do
        expect { Togls::FeatureRepository.new([]) }.to raise_error(Togls::MissingDriver)
      end
    end

    context "when not given an array" do
      it "raises an exception" do
        expect { Togls::FeatureRepository.new("something else") }.to raise_error(Togls::InvalidDriver)
      end
    end
  end

  describe "#store" do
    it "extracts the feature data" do
      feature = Togls::Feature.new("some_feature_key", "Some Feature Desc", :hoopty)
      expect(subject).to receive(:extract_feature_data).with(feature)
      allow(driver).to receive(:store)
      subject.store(feature)
    end

    it "iterate over each driver" do
      feature = Togls::Feature.new("some_feature_key", "Some Feature Desc", :hoopty)
      expect(subject.instance_variable_get(:@drivers)).to receive(:each)
      subject.store(feature)
    end

    it "store the toggle in each driver" do
      feature = Togls::Feature.new("some_feature_key", "Some Feature Desc", :hoopty)
      feature_data = double('feature data')
      allow(subject).to receive(:extract_feature_data).and_return(feature_data)
      allow(subject.instance_variable_get(:@drivers)).to receive(:each).and_yield(driver)
      expect(driver).to receive(:store).with(feature.id, feature_data)
      subject.store(feature)
    end
  end

  describe "#extract_feature_data" do
    it "returns the feature's extracted feature data" do
      feature = Togls::Feature.new("some_feature_key", "Some Feature Desc", :some_target_type)
      expect(subject.extract_feature_data(feature))
        .to eq({ "key" => "some_feature_key", "description" => "Some Feature Desc", "target_type" => "some_target_type" })
    end
  end

  describe "#fetch_feature_data" do
    it "reverse the drivers" do
      drivers = subject.instance_variable_get(:@drivers)
      expect(drivers).to receive(:reverse).and_return([])
      subject.fetch_feature_data("some id")
    end

    it "iterate over each driver in reverse order" do
      drivers = subject.instance_variable_get(:@drivers)
      reversed_drivers = double('reversed drivers')
      allow(drivers).to receive(:reverse).and_return(reversed_drivers)
      expect(reversed_drivers).to receive(:each)
      subject.fetch_feature_data("some id")
    end

    it "attempt to get the feature data from each driver" do
      driver = double('driver')
      drivers = subject.instance_variable_get(:@drivers)
      reversed_drivers = double('reversed drivers')
      allow(drivers).to receive(:reverse).and_return(reversed_drivers)
      allow(reversed_drivers).to receive(:each).and_yield(driver)
      expect(driver).to receive(:get).with("some id")
      subject.fetch_feature_data("some id")
    end

    it "short circuits at the first feature it finds" do
      feature_data = double('feature data')
      driver_one = double('driver one')
      driver_two = double('driver two')
      drivers = subject.instance_variable_get(:@drivers)
      reversed_drivers = double('reversed drivers')
      allow(drivers).to receive(:reverse).and_return(reversed_drivers)
      allow(reversed_drivers).to receive(:each).and_yield(driver_one).and_yield(driver_two)
      expect(driver_one).to receive(:get).with("some id").and_return(feature_data)
      expect(driver_two).not_to receive(:get).with("some id")
      subject.fetch_feature_data("some id")
    end

    context "when it finds a feature data" do
      it "returns the first feature data it finds" do
        feature_data = double('feature data')
        driver_one = double('driver one')
        driver_two = double('driver two')
        drivers = subject.instance_variable_get(:@drivers)
        reversed_drivers = double('reversed drivers')
        allow(drivers).to receive(:reverse).and_return(reversed_drivers)
        allow(reversed_drivers).to receive(:each).and_yield(driver_one).and_yield(driver_two)
        allow(driver_one).to receive(:get).with("some id").and_return(feature_data)
        expect(subject.fetch_feature_data("some id")).to eq(feature_data)
      end
    end

    context "when it doesn't find a feature" do
      it "returns nil" do
        feature_data = double('feature data')
        driver_one = double('driver one')
        driver_two = double('driver two')
        drivers = subject.instance_variable_get(:@drivers)
        reversed_drivers = double('reversed drivers')
        allow(drivers).to receive(:reverse).and_return(reversed_drivers)
        allow(reversed_drivers).to receive(:each).and_yield(driver_one).and_yield(driver_two)
        allow(driver_one).to receive(:get).with("some id").and_return(nil)
        allow(driver_two).to receive(:get).with("some id").and_return(nil)
        expect(subject.fetch_feature_data("some id")).to be_nil
      end
    end
  end

  describe "#include?" do
    it "fetches the feature data from the drivers" do
      expect(subject).to receive(:fetch_feature_data).with("some_id")
      subject.include?("some_id")
    end

    context "when feature data is fetched" do
      it "returns true" do
        allow(subject).to receive(:fetch_feature_data).and_return({ "some": "data" })
        expect(subject.include?("some_id")).to be_truthy
      end
    end

    context "when feature data can't be found" do
      it "returns false" do
        allow(subject).to receive(:fetch_feature_data).and_return(nil)
        expect(subject.include?("some_id")).to be_falsey
      end
    end
  end

  describe "#get" do
    it "get the feature data" do
      allow(subject).to receive(:reconstitute_feature)
      allow(subject).to receive(:validate_feature_data)
      expect(subject).to receive(:fetch_feature_data).with("some_id")
      subject.get("some_id")
    end

    it 'validates the feature data' do
      feature_data = { "key" => "some_key", "description" => "some desc",
        "target_type" => "some_target_type" }
      allow(subject).to receive(:fetch_feature_data).and_return(feature_data)
      expect(subject).to receive(:validate_feature_data).with(feature_data)
      subject.get("some_id")
    end

    it "reconstitutes a feature" do
      feature_data = double('feature data')
      allow(subject).to receive(:validate_feature_data)
      allow(subject).to receive(:fetch_feature_data).and_return(feature_data)
      expect(subject).to receive(:reconstitute_feature).with(feature_data)
      subject.get("some_id")
    end

    it "returns the feature" do
      feature = double('feature')
      allow(subject).to receive(:validate_feature_data)
      allow(subject).to receive(:fetch_feature_data)
      allow(subject).to receive(:reconstitute_feature).and_return(feature)
      expect(subject.get("some_id")).to eq(feature)
    end
  end

  describe "#reconstitute_feature" do
    it "constructs a feature from the feature data" do
      expect(Togls::Feature).to receive(:new).with("some_key", "some desc",
                                                   :some_target_type)
      subject.reconstitute_feature({ "key" => "some_key",
                                     "description" => "some desc",
                                     "target_type" => "some_target_type" })
    end

    it "returns the feature" do
      feature = double('feature')
      allow(Togls::Feature).to receive(:new).and_return(feature)
      expect(subject.reconstitute_feature({ "key" => "some_key", "description" => "some desc",
                                            "target_type" => 'some target type' })).to eq(feature)
    end
  end

  describe '#validate_feature_data' do
    context 'when feature data is complete and proper' do
      it 'does not raise an exception' do
        feature_data = { "key" => "some_key", "description" => "some desc",
          "target_type" => "some_target_type" }
        expect {
          subject.validate_feature_data(feature_data)
        }.not_to raise_error
      end
    end

    context 'when feature data is nil' do
      it 'logs and raises an exception' do
        feature_data = nil
        expect(Togls.logger).to receive(:debug).with("None of the feature repository drivers claim to have the feature")
        expect {
          subject.validate_feature_data(feature_data)
        }.to raise_error(Togls::RepositoryFeatureDataInvalid)
      end
    end

    context 'when feature data is missing key' do
      it 'logs and raises an exception' do
        feature_data = { "description" => "some desc",
          "target_type" => "some_target_type" }
        expect(Togls.logger).to receive(:debug).with("One of the feature repository drivers returned feature data that is missing the 'key'")
        expect {
          subject.validate_feature_data(feature_data)
        }.to raise_error(Togls::RepositoryFeatureDataInvalid)
      end
    end

    context 'when feature data is missing description' do
      it 'logs and raises an exception' do
        feature_data = { "key" => "some_key",
          "target_type" => "some_target_type" }
        expect(Togls.logger).to receive(:debug).with("One of the feature repository drivers returned feature data that is missing the 'description'")
        expect {
          subject.validate_feature_data(feature_data)
        }.to raise_error(Togls::RepositoryFeatureDataInvalid)
      end
    end

    context 'when feature data is missing target_type' do
      it 'logs and raises an exception' do
        feature_data = { "key" => "some_key", "description" => "some desc" }
        expect(Togls.logger).to receive(:debug).with("One of the feature repository drivers returned feature data that is missing the 'target_type'")
        expect {
          subject.validate_feature_data(feature_data)
        }.to raise_error(Togls::RepositoryFeatureDataInvalid)
      end
    end

    context 'when feature data key is not a string' do
      it 'logs and raises an exception' do
        feature_data = { "key" => 12342, "description" => "some desc", "target_type" => "some_target_type" }
        expect(Togls.logger).to receive(:debug).with("One of the feature repository drivers returned feature data with 'key' not being a string")
        expect {
          subject.validate_feature_data(feature_data)
        }.to raise_error(Togls::RepositoryFeatureDataInvalid)
      end
    end

    context 'when feature data description is not a string' do
      it 'logs and raises an exception' do
        feature_data = { "key" => "foo", "description" => 234324, "target_type" => "some_target_type" }
        expect(Togls.logger).to receive(:debug).with("One of the feature repository drivers returned feature data with 'description' not being a string")
        expect {
          subject.validate_feature_data(feature_data)
        }.to raise_error(Togls::RepositoryFeatureDataInvalid)
      end
    end

    context 'when feature data target_type is not a string' do
      it 'logs and raises an exception' do
        feature_data = { "key" => "foo", "description" => "aoeuaoe", "target_type" => 2343242 }
        expect(Togls.logger).to receive(:debug).with("One of the feature repository drivers returned feature data with 'target_type' not being a string")
        expect {
          subject.validate_feature_data(feature_data)
        }.to raise_error(Togls::RepositoryFeatureDataInvalid)
      end
    end
  end
end
