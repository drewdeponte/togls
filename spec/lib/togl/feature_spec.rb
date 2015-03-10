require 'spec_helper'

describe Togl::Feature do
  subject { Togl::Feature.new(:key) }
  describe "#initialize" do
    it "assigns the passed key" do
      expect(subject.key).to eq(:key)
    end
  end

  describe "#on" do
    it "sets the feature state to on" do
      subject.on
      expect(subject.instance_variable_get(:@state)).to eq(:on)
    end
  end

  describe "#on?" do
    context "when state is on" do
      it "returns true" do
        subject.on
        expect(subject.on?).to eq(true)
      end
    end
  end
end
