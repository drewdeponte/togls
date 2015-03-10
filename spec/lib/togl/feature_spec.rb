require 'spec_helper'

describe Togl::Feature do
  subject { Togl::Feature.new(:key) }
  describe "#initialize" do
    it "assigns the passed key" do
      expect(subject.key).to eq(:key)
    end

    it "defaults to off" do
      expect(subject.on?).to eq(false)
    end
  end

  describe "#on" do
    context "when the rule is nil" do
      it "creates a new rule" do
        expect(Togl::Rule).to receive(:new).twice
        subject.on
      end
    end

    it "sets the feature rule to true" do
      subject.on
      expect(subject.instance_variable_get(:@rule).run).to eq(true)
    end
  end

  describe "#on?" do
    it "runs the associated rule" do
      rule = double('rule')
      target = double('target')
      subject.instance_variable_set(:@rule, rule)
      expect(rule).to receive(:run).with(target)
      subject.on?(target)
    end

    context "when state is on" do
      it "returns true" do
        subject.on
        expect(subject.on?).to eq(true)
      end
    end
  end

  describe "#off" do
    context "when the rule is nil" do
      it "creates a new rule" do
        expect(Togl::Rule).to receive(:new).twice
        subject.off
      end
    end

    it "sets the feature rule to false" do
      subject.off
      expect(subject.instance_variable_get(:@rule).run).to eq(false)
    end
  end
end
