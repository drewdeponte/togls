require 'spec_helper'

describe Togls::RuleRepository do
  let(:driver) { double('driver') }
  subject { Togls::RuleRepository.new([driver]) }

  describe "#initialize" do
    context "when given an array of 1 or more drivers" do
      it "constructs a toggle repository" do
        driver = double('driver')
        repository = Togls::RuleRepository.new([driver])
        expect(repository).to be_a(Togls::RuleRepository)
      end

      it "assigns the given drivers" do
        driver = double('driver')
        repository = Togls::RuleRepository.new([driver])
        expect(repository.instance_variable_get(:@drivers)).to eq([driver])
      end
    end

    context "when given an empty array of drivers" do
      it "raises an exception" do
        expect { Togls::RuleRepository.new([]) }.to raise_error(Togls::MissingDriver)
      end
    end

    context "when not given an array" do
      it "raises an exception" do
        expect { Togls::RuleRepository.new("something else") }.to raise_error(Togls::InvalidDriver)
      end
    end
  end

  describe "#store" do
    it "iterate over each driver" do
      rule = instance_double(Togls::Rule)
      expect(subject.instance_variable_get(:@drivers)).to receive(:each)
      subject.store(rule)
    end

    it "store the toggle in each driver" do
      rule = instance_double(Togls::Rule)
      allow(subject.instance_variable_get(:@drivers)).to receive(:each).and_yield(driver)
      expect(driver).to receive(:store).with(rule)
      subject.store(rule)
    end
  end
end
