require_relative '../../spec_helper'

describe Togls::Feature do
  subject { Togls::Feature.new(:key, "some description",
                               Togls::Rules::Boolean) }

  describe "#initialize" do
    it "assigns the passed key" do
      expect(subject.key).to eq(:key)
    end

    it "assigns the description" do
      expect(subject.description).to eq("some description")
    end

    it "defaults to off" do
      expect(subject.on?).to eq(false)
    end
  end

  describe "#on" do
    context "when the rule is nil" do
      it "creates a new rule" do
        expect(Togls::Rule).to receive(:new).twice
        subject.on
      end
    end

    it "sets the feature rule to true" do
      subject.on
      expect(subject.instance_variable_get(:@rule).run(double('feature key'))).to eq(true)
    end

    it "returns its associated feature object" do
      retval = subject.on
      expect(retval).to eq(subject)
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

  describe "#on?" do
    it "runs the associated rule" do
      rule = double('rule')
      target = double('target')
      subject.instance_variable_set(:@rule, rule)
      expect(rule).to receive(:run).with(subject.key, target)
      subject.on?(target)
    end

    context "when state is on" do
      it "returns true" do
        subject.on
        expect(subject.on?).to eq(true)
      end
    end
  end

  describe "#description" do
    it "returns the description" do
      expect(subject.description).to eq("some description")
    end
  end

  describe "#to_s" do
    context "when based on boolean rule" do
      it "returns a human readable string representation of the feature including value" do
        feature = Togls::Feature.new(:key, "some description",
                                     Togls::Rules::Boolean).on(Togls::Rules::Boolean.new(true))
        expect(feature.to_s).to eq(" on - :key - some description")
      end
    end

    context "when NOT based on boolean rule" do
      it "returns a human readable string representation of the feature with an unknown value" do
        rule = Togls::Rule.new { |v| !v }
        feature = Togls::Feature.new(:another_key, "another description", Togls::Rules::Boolean).on(rule)
        expect(feature.to_s).to eq("  ? - :another_key - another description")
      end
    end
  end
end
