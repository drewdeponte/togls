require 'spec_helper'

describe Togls::Toggle do
  let(:feature) { double(Togls::Feature) }
  subject { Togls::Toggle.new(feature) }

  describe "#initalize" do
    it "creats a instance of Toggle" do
      expect(subject).to be_a(Togls::Toggle)
    end

    it "assigns the given feature" do
      expect(subject.instance_variable_get(:@feature)).to eq(feature)
    end

    it "assigns a new falsey rule" do
      expect(subject.instance_variable_get(:@rule)).not_to be_nil
    end
  end

  describe "#id" do
    it "returns the associated features id as the toggles id" do
      allow(feature).to receive(:id).and_return("foo")
      expect(subject.id).to eq("foo")
    end
  end

  describe "#feature" do
    it "returns the feature of the toggle" do
      expect(subject.feature).to eq(feature)      
    end
  end

  describe "#rule" do
    it "returns the rule of the toggle" do
      rule = double('rule')
      subject.instance_variable_set(:@rule, rule)
      expect(subject.rule).to eq(rule)      
    end
  end

  describe "#rule=" do
    it "sets the rule of the toggle" do
      rule = double('rule')
      subject.rule = rule
      expect(subject.instance_variable_get(:@rule)).to eq(rule)
    end
  end

  describe "#on?" do
    it "runs the associated rule" do
      rule = double('rule')
      target = double('target')
      subject.instance_variable_set(:@rule, rule)
      allow(feature).to receive(:key).and_return("key")
      expect(rule).to receive(:run).with(subject.feature.key, target)
      subject.on?(target)
    end

    it "returns the result of run" do
      rule = double('rule')
      target = double('target')
      result = double('result')
      subject.instance_variable_set(:@rule, rule)
      allow(feature).to receive(:key).and_return("key")
      allow(rule).to receive(:run).and_return(result)
      expect(subject.on?(target)).to eq(result)
    end
  end

  describe "#to_s" do
    context "when based on boolean rule" do
      it "returns a human readable string representation of the feature including value" do
        toggle = Togls::Toggle.new(Togls::Feature.new(:key, "some description"))
        toggle.rule = Togls::Rules::Boolean.new(true)
        expect(toggle.to_s).to eq(" on - key - some description")
      end
    end

    context "when NOT based on boolean rule" do
      it "returns a human readable string representation of the feature with an unknown value" do
        rule = Togls::Rule.new(true)
        toggle = Togls::Toggle.new(Togls::Feature.new(:another_key, "another description"))
        toggle.rule = rule
        expect(toggle.to_s).to eq("  ? - another_key - another description")
      end
    end
  end
end
