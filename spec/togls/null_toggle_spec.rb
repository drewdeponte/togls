require 'spec_helper'

RSpec.describe Togls::NullToggle do
  describe "#initialize" do
    it "constructs a null feature" do
      expect(Togls::Feature).to receive(:new).with("null", "the official null feature", Togls::TargetTypes::EITHER)
      subject
    end
  end

  describe "#on" do
    it "returns self" do
      expect(subject.on).to eq(subject)
    end
  end

  describe "#off" do
    it "returns self" do
      expect(subject.off).to eq(subject)
    end
  end
end
