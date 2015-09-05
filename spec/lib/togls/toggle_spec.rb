require 'spec_helper'

describe Togls::Toggle do
  let(:feature) { double Togls::Feature }
  let(:base_rule_type_klass) { Togls::Rules::Boolean }
  subject { Togls::Toggle.new(feature, base_rule_type_klass) }

  describe "#initalize" do
    it "creats a instance of Toggle" do
      expect(subject).to be_a(Togls::Toggle)
    end

    it "assigns the given feature" do
      expect(subject.instance_variable_get(:@feature)).to eq(feature)
    end

    it "assigns the base rule type klass" do
      expect(subject.instance_variable_get(:@base_rule_type_klass)).to eq(base_rule_type_klass)
    end

    it "assigns a new falsey rule" do
      expect(subject.instance_variable_get(:@rule)).not_to be_nil
    end
  end

  describe "#on" do
    context "when the rule is nil" do
      it "creates a new rule" do
        expect(Togls::Rule).to receive(:new).twice
        subject.on
      end
    end

    it "sets the feature toggle's rule to true" do
      subject.on
      expect(subject.instance_variable_get(:@rule).run(double('feature key'))).to eq(true)
    end

    it "returns its associated toggle object" do
      return_val = subject.on
      expect(return_val).to eq(subject)
    end
  end

  describe "#off" do
    context "when the rule is nil" do
      it "creates a new rule" do
        expect(Togls::Rule).to receive(:new).twice
        subject.off
      end
    end

    it "sets the feature rule to false" do
      subject.off
      expect(subject.instance_variable_get(:@rule).\
             run(double('feature key'))).to eq(false)
    end

    it "returns its associated feature object" do
      retval = subject.off
      expect(retval).to eq(subject)
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

  describe "#on?" do
    it "runs the associated rule" do
      rule = double('rule')
      target = double('target')
      subject.instance_variable_set(:@rule, rule)
      allow(feature).to receive(:key).and_return("key")
      expect(rule).to receive(:run).with(subject.feature.key, target)
      subject.on?(target)
    end

    context "when state is on" do
      it "returns true" do
        allow(feature).to receive(:key).and_return("key")
        subject.on
        expect(subject.on?).to eq(true)
      end
    end
  end

  describe "#to_s" do
    context "when based on boolean rule" do
      it "returns a human readable string representation of the feature including value" do
        toggle = Togls::Toggle.new(Togls::Feature.new(:key, "some description"),
                                     Togls::Rules::Boolean).on(Togls::Rules::Boolean.new(true))
        expect(toggle.to_s).to eq(" on - key - some description")
      end
    end

    context "when NOT based on boolean rule" do
      it "returns a human readable string representation of the feature with an unknown value" do
        rule = Togls::Rule.new { |v| !v }
        toggle = Togls::Toggle.new(Togls::Feature.new(:another_key, "another description"),
                                     Togls::Rules::Boolean).on(rule)
        expect(toggle.to_s).to eq("  ? - another_key - another description")
      end
    end
  end
end
