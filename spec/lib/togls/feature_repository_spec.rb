require 'spec_helper'

describe Togls::FeatureRepository do
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
    it "iterate over each driver" do
      feature = instance_double(Togls::Feature)
      expect(subject.instance_variable_get(:@drivers)).to receive(:each)
      subject.store(feature)
    end

    it "store the toggle in each driver" do
      feature = instance_double(Togls::Feature)
      allow(subject.instance_variable_get(:@drivers)).to receive(:each).and_yield(driver)
      expect(driver).to receive(:store).with(feature)
      subject.store(feature)
    end
  end
end
