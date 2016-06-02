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
      allow(subject).to receive(:target_matches?).and_return(true)
      subject.rule = rule
      expect(subject.instance_variable_get(:@rule)).to eq(rule)
    end

    context 'when given a rule which belongs to a class that has a mismatched target type' do
      it 'raises a target type mismatch error' do
        rule = double('rule')
        allow(subject).to receive(:target_matches?).and_return(false)
        expect {
          subject.rule = rule
        }.to raise_error(Togls::RuleFeatureTargetTypeMismatch)
      end
    end
  end

  describe '#target_matches?' do
    context 'when the rule has no target type' do
      context 'when the rule types target type matches the features target type' do
        it 'returns true' do
          feature = Togls::Feature.new('some name', 'some desc', :hoopty)
          toggle = Togls::Toggle.new(feature)

          rule_klass = Class.new(Togls::Rule) do
            def self.target_type
              :hoopty
            end
          end
          rule = rule_klass.new

          result = toggle.target_matches?(rule)
          expect(result).to eql true
        end
      end

      context 'when the rule types target type does NOT match the features target type' do
        context 'when the rule types target type is for ANY target type' do
          it 'returns true' do
            feature = Togls::Feature.new('some name', 'some desc', :jokes)
            toggle = Togls::Toggle.new(feature)

            rule_klass = Class.new(Togls::Rule) do
              def self.target_type
                Togls::TargetTypes::ANY
              end
            end
            rule = rule_klass.new

            result = toggle.target_matches?(rule)
            expect(result).to eql true
          end
        end

        context 'when the rule types target type is NOT for ANY target type' do
          it 'returns false' do
            feature = Togls::Feature.new('some name', 'some desc', :foo)
            toggle = Togls::Toggle.new(feature)

            rule_klass = Class.new(Togls::Rule) do
              def self.target_type
                :bar
              end
            end
            rule = rule_klass.new

            result = toggle.target_matches?(rule)
            expect(result).to eql false
          end
        end
      end
    end

    context 'when the rule has a target type' do
      context 'when the rule target type matches the features target type' do
        it 'returns true' do
          feature = Togls::Feature.new('some name', 'some desc', :hoopty)
          toggle = Togls::Toggle.new(feature)

          rule = Togls::Rule.new('something', target_type: :hoopty)

          result = toggle.target_matches?(rule)
          expect(result).to eql true
        end
      end

      context 'when the rule target type does NOT match the features target type' do
        context 'when the rule target type is for ANY target type' do
          it 'returns true' do
            feature = Togls::Feature.new('some name', 'some desc', :hoopty)
            toggle = Togls::Toggle.new(feature)

            rule = Togls::Rule.new('something', target_type: Togls::TargetTypes::ANY)

            result = toggle.target_matches?(rule)
            expect(result).to eql true
          end
        end

        context 'when the rule target type is NOT for ANY target type' do
          it 'returns false' do
            feature = Togls::Feature.new('some name', 'some desc', :hoopty)
            toggle = Togls::Toggle.new(feature)

            rule = Togls::Rule.new('something', target_type: :bar)

            result = toggle.target_matches?(rule)
            expect(result).to eql false
          end
        end
      end
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

  describe "#off?" do
    it "runs the associated rule" do
      rule = double('rule')
      target = double('target')
      subject.instance_variable_set(:@rule, rule)
      allow(feature).to receive(:key).and_return("key")
      expect(rule).to receive(:run).with(subject.feature.key, target)
      subject.off?(target)
    end

    it "returns the opposite boolean of the result of run" do
      rule = double('rule')
      target = double('target')
      result = false
      subject.instance_variable_set(:@rule, rule)
      allow(feature).to receive(:key).and_return("key")
      allow(rule).to receive(:run).and_return(result)
      expect(subject.off?(target)).to eq(true)
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
