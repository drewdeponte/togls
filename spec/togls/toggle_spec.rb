require 'spec_helper'

RSpec.describe Togls::Toggle do
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
    context 'when the features target type is not set' do
      context 'when the rules target type is not set' do
        it 'logs that the rule is broken' do
          feature = Togls::Feature.new('some name', 'some desc', Togls::TargetTypes::NONE)
          feature.instance_variable_set(:@target_type, Togls::TargetTypes::NOT_SET)
          toggle = Togls::Toggle.new(feature)

          rule_klass = Class.new(Togls::Rule) do
            def self.target_type
              :hoopty
            end
          end
          rule = rule_klass.new(:hoopty)
          allow(rule_klass).to receive(:target_type).and_return(Togls::TargetTypes::NOT_SET)

          expect(Togls.logger).to receive(:warn).with("Rule (id: #{rule.id}) cannot have target type of :not_set")
          toggle.target_matches?(rule)
        end

        it 'returns false' do
          allow(Togls.logger).to receive(:warn)
          feature = Togls::Feature.new('some name', 'some desc', Togls::TargetTypes::NONE)
          feature.instance_variable_set(:@target_type, Togls::TargetTypes::NOT_SET)
          toggle = Togls::Toggle.new(feature)

          rule_klass = Class.new(Togls::Rule) do
            def self.target_type
              :hoopty
            end
          end
          rule = rule_klass.new(:hoopty)
          allow(rule_klass).to receive(:target_type).and_return(Togls::TargetTypes::NOT_SET)

          result = toggle.target_matches?(rule)
          expect(result).to eql false
        end
      end

      context 'when the rules target type is set to none' do
        it 'returns true' do
          feature = Togls::Feature.new('some name', 'some desc', Togls::TargetTypes::NONE)
          feature.instance_variable_set(:@target_type, Togls::TargetTypes::NOT_SET)
          toggle = Togls::Toggle.new(feature)

          rule_klass = Class.new(Togls::Rule) do
            def self.target_type
              Togls::TargetTypes::NONE
            end
          end
          rule = rule_klass.new(:sometypeid)

          result = toggle.target_matches?(rule)
          expect(result).to eql true
        end
      end

      context 'when the rules target type is specified' do
        it 'logs that the feature is broken' do
          feature = Togls::Feature.new('some name', 'some desc', Togls::TargetTypes::NONE)
          feature.instance_variable_set(:@target_type, Togls::TargetTypes::NOT_SET)
          toggle = Togls::Toggle.new(feature)

          rule_klass = Class.new(Togls::Rule) do
            def self.target_type
              :foo
            end
          end
          rule = rule_klass.new(:sometypeid)

          expect(Togls.logger).to receive(:warn).with("Feature (key: #{feature.key}) cannot have target type of :not_set when rule (id: #{rule.id}) specifies a target type (target_type: #{rule.target_type}")
          toggle.target_matches?(rule)
        end

        it 'returns false' do
          allow(Togls.logger).to receive(:warn)
          feature = Togls::Feature.new('some name', 'some desc', Togls::TargetTypes::NONE)
          feature.instance_variable_set(:@target_type, Togls::TargetTypes::NOT_SET)
          toggle = Togls::Toggle.new(feature)

          rule_klass = Class.new(Togls::Rule) do
            def self.target_type
              :foo
            end
          end
          rule = rule_klass.new(:sometypeid)

          result = toggle.target_matches?(rule)
          expect(result).to eql false
        end
      end
    end

    context 'when the features target type is set to none' do
      context 'when the rules target type is set to none' do
        it 'returns true' do
          feature = Togls::Feature.new('some name', 'some desc', Togls::TargetTypes::NONE)
          toggle = Togls::Toggle.new(feature)

          rule_klass = Class.new(Togls::Rule) do
            def self.target_type
              Togls::TargetTypes::NONE
            end
          end
          rule = rule_klass.new(:sometypeid)

          result = toggle.target_matches?(rule)
          expect(result).to eql true
        end
      end

      context 'when the rules target type is specified' do
        it 'returns false' do
          feature = Togls::Feature.new('some name', 'some desc', Togls::TargetTypes::NONE)
          toggle = Togls::Toggle.new(feature)

          rule_klass = Class.new(Togls::Rule) do
            def self.target_type
              :foo
            end
          end
          rule = rule_klass.new(:sometypeid)

          result = toggle.target_matches?(rule)
          expect(result).to eql false
        end
      end

      context 'when the rules target type is not set' do
        it 'logs that the rule is broken' do
          feature = Togls::Feature.new('some name', 'some desc', Togls::TargetTypes::NONE)
          toggle = Togls::Toggle.new(feature)

          rule_klass = Class.new(Togls::Rule) do
            def self.target_type
              :foo
            end
          end
          rule = rule_klass.new(:sometypeid)
          allow(rule_klass).to receive(:target_type).and_return(Togls::TargetTypes::NOT_SET)

          expect(Togls.logger).to receive(:warn).with("Rule (id: #{rule.id}) cannot have target type of :not_set")
          toggle.target_matches?(rule)
        end

        it 'returns false' do
          allow(Togls.logger).to receive(:warn)
          feature = Togls::Feature.new('some name', 'some desc', Togls::TargetTypes::NONE)
          toggle = Togls::Toggle.new(feature)

          rule_klass = Class.new(Togls::Rule) do
            def self.target_type
              :hoopty
            end
          end
          rule = rule_klass.new(:sometypeid)
          allow(rule_klass).to receive(:target_type).and_return(Togls::TargetTypes::NOT_SET)

          result = toggle.target_matches?(rule)
          expect(result).to eql false
        end
      end
    end

    context 'when the features target type is specified' do
      context 'when the rules target type is set to none' do
        it 'returns true' do
          feature = Togls::Feature.new('some name', 'some desc', :foo)
          toggle = Togls::Toggle.new(feature)

          rule_klass = Class.new(Togls::Rule) do
            def self.target_type
              Togls::TargetTypes::NONE
            end
          end
          rule = rule_klass.new(:sometypeid)

          result = toggle.target_matches?(rule)
          expect(result).to eql true
        end
      end

      context 'when the rules target type is explicitly set to match' do
        it 'returns true' do
          feature = Togls::Feature.new('some name', 'some desc', :foo)
          toggle = Togls::Toggle.new(feature)

          rule_klass = Class.new(Togls::Rule) do
            def self.target_type
              :foo
            end
          end
          rule = rule_klass.new(:sometypeid)

          result = toggle.target_matches?(rule)
          expect(result).to eql true
        end
      end

      context 'when the rules target type is not set' do
        it 'logs that the rule is broken' do
          feature = Togls::Feature.new('some name', 'some desc', :foo)
          toggle = Togls::Toggle.new(feature)

          rule_klass = Class.new(Togls::Rule) do
            def self.target_type
              :foo
            end
          end
          rule = rule_klass.new(:sometypeid)
          allow(rule_klass).to receive(:target_type).and_return(Togls::TargetTypes::NOT_SET)

          expect(Togls.logger).to receive(:warn).with("Rule (id: #{rule.id}) cannot have target type of :not_set")
          toggle.target_matches?(rule)
        end

        it 'returns false' do
          allow(Togls.logger).to receive(:warn)
          feature = Togls::Feature.new('some name', 'some desc', :foo)
          toggle = Togls::Toggle.new(feature)

          rule_klass = Class.new(Togls::Rule) do
            def self.target_type
              :foo
            end
          end
          rule = rule_klass.new(:sometypeid)
          allow(rule_klass).to receive(:target_type).and_return(Togls::TargetTypes::NOT_SET)

          result = toggle.target_matches?(rule)
          expect(result).to eql false
        end
      end

      context 'when the rules target type is explicitly set to NOT match' do
        it 'returns false' do
          feature = Togls::Feature.new('some name', 'some desc', :foo)
          toggle = Togls::Toggle.new(feature)

          rule_klass = Class.new(Togls::Rule) do
            def self.target_type
              :bar
            end
          end
          rule = rule_klass.new(:sometypeid)

          result = toggle.target_matches?(rule)
          expect(result).to eql false
        end
      end
    end
  end

  describe "#validate_target" do
    context 'when the feature target type contract is NONE' do
      context 'when the target is not nil' do
        it 'raises an exception' do
          feature = Togls::Feature.new(:foo, 'desc', Togls::TargetTypes::NONE)
          toggle = Togls::Toggle.new(feature)
          expect {
            toggle.validate_target('asdf')
          }.to raise_error Togls::UnexpectedEvaluationTarget
        end
      end

      context 'when the target is nil' do
        it 'succeeds at validating' do
          feature = Togls::Feature.new(:foo, 'desc', Togls::TargetTypes::NONE)
          toggle = Togls::Toggle.new(feature)
          expect {
            toggle.validate_target(nil)
          }.not_to raise_error
        end
      end
    end

    context 'when the feature target type contract is NOT_SET' do
      it 'succeeds at validating' do
        feature = Togls::Feature.new(:foo, 'desc', :foo)
        feature.instance_variable_set(:@target_type, Togls::TargetTypes::NOT_SET)
        toggle = Togls::Toggle.new(feature)
        expect {
          toggle.validate_target('asdf')
        }.not_to raise_error
      end
    end

    context 'when the feature target type contract is EITHER' do
      context 'when the target is not nil' do
        it 'succeeds at validating' do
          feature = Togls::Feature.new(:foo, 'desc', :foo)
          feature.instance_variable_set(:@target_type, Togls::TargetTypes::EITHER)
          toggle = Togls::Toggle.new(feature)
          expect {
            toggle.validate_target('asdf')
          }.not_to raise_error
        end
      end

      context 'when the target is nil' do
        it 'succeeds at validating' do
          feature = Togls::Feature.new(:foo, 'desc', :foo)
          feature.instance_variable_set(:@target_type, Togls::TargetTypes::EITHER)
          toggle = Togls::Toggle.new(feature)
          expect {
            toggle.validate_target(nil)
          }.not_to raise_error
        end
      end
    end

    context 'when the feature target type contract specifies a target type' do
      context 'when the target is not nil' do
        it 'succeeds at validating' do
          feature = Togls::Feature.new(:name, 'desc', :foo)
          rule = Togls::Rule.new(:sometypeid, target_type: :foo)
          toggle = Togls::Toggle.new(feature)
          toggle.rule = rule
          expect {
            toggle.validate_target('asdf')
          }.not_to raise_error
        end
      end

      context 'when the target is nil' do
        it 'raises an exception' do
          feature = Togls::Feature.new(:name, 'desc', :foo)
          rule = Togls::Rule.new(:sometypeid, target_type: :foo)
          toggle = Togls::Toggle.new(feature)
          toggle.rule = rule
          expect {
            toggle.validate_target(nil)
          }.to raise_error Togls::EvaluationTargetMissing
        end
      end
    end
  end

  describe "#on?" do
    it 'validates target against feature contract' do
      target = double('target')
      allow(feature).to receive(:key).and_return("key")
      expect(subject).to receive(:validate_target).with(target)
      subject.on?(target)
    end

    it "runs the associated rule" do
      rule = double('rule')
      target = double('target')
      subject.instance_variable_set(:@rule, rule)
      allow(subject).to receive(:validate_target).with(target)
      allow(feature).to receive(:key).and_return("key")
      expect(rule).to receive(:run).with(subject.feature.key, target)
      subject.on?(target)
    end

    it "returns the result of run" do
      rule = double('rule')
      target = double('target')
      result = double('result')
      subject.instance_variable_set(:@rule, rule)
      allow(subject).to receive(:validate_target).with(target)
      allow(feature).to receive(:key).and_return("key")
      allow(rule).to receive(:run).and_return(result)
      expect(subject.on?(target)).to eq(result)
    end
  end

  describe "#off?" do
    it 'validates target against feature contract' do
      target = double('target')
      allow(feature).to receive(:key).and_return("key")
      expect(subject).to receive(:validate_target).with(target)
      subject.off?(target)
    end

    it "runs the associated rule" do
      rule = double('rule')
      target = double('target')
      subject.instance_variable_set(:@rule, rule)
      allow(subject).to receive(:validate_target).with(target)
      allow(feature).to receive(:key).and_return("key")
      expect(rule).to receive(:run).with(subject.feature.key, target)
      subject.off?(target)
    end

    it "returns the opposite boolean of the result of run" do
      rule = double('rule')
      target = double('target')
      result = false
      subject.instance_variable_set(:@rule, rule)
      allow(subject).to receive(:validate_target).with(target)
      allow(feature).to receive(:key).and_return("key")
      allow(rule).to receive(:run).and_return(result)
      expect(subject.off?(target)).to eq(true)
    end
  end
end
