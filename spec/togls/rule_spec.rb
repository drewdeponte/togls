require 'spec_helper'

RSpec.describe Togls::Rule do
  describe '.title' do
    it 'raises NotImplemented exception' do
      klass = Class.new(Togls::Rule)
      expect { klass.title }.to raise_error(Togls::NotImplemented)
    end
  end

  describe '.description' do
    it 'raises NotImplemented exception' do
      klass = Class.new(Togls::Rule)
      expect { klass.description }.to raise_error(Togls::NotImplemented)
    end
  end

  describe '.target_type' do
    it 'returns the default of not set' do
      klass = Class.new(Togls::Rule)
      expect(klass.target_type).to eq(Togls::TargetTypes::NOT_SET)
    end
  end

  describe '#initialize' do
    it 'assigns the given id to an instance variable' do
      rule = Togls::Rule.new(:some_rule, :hoopty, double, target_type: :foo)
      expect(rule.instance_variable_get(:@id)).to eq(:some_rule)
    end

    context 'when given initialization data' do
      context 'when given target type' do
        it 'assigns the given type_id to an instance variable' do
          rule = Togls::Rule.new(:some_rule, :hoopty, double, target_type: :foo)
          expect(rule.instance_variable_get(:@type_id)).to eq(:hoopty)
        end

        it 'assigns the given data to an instance variable' do
          data = double('data')
          rule = Togls::Rule.new(:some_rule, :hoopty, data, target_type: :foo)
          expect(rule.instance_variable_get(:@data)).to eq(data)
        end

        it 'assigns the given target type to an instance variable' do
          rule = Togls::Rule.new(:some_rule, :hoopty, target_type: :some_target_type)
          expect(rule.instance_variable_get(:@target_type)).to eq(:some_target_type)
        end
      end

      context 'when not given target type' do
        context 'when rule type did not set target type' do
          it 'raises target type missing exception' do
            expect {
              rule = Togls::Rule.new(:some_rule, :hoopty)
            }.to raise_error(Togls::RuleMissingTargetType)
          end
        end

        context 'when rule type did set target type' do
          it 'return the rule types target type' do
            rule_klass = Class.new(Togls::Rule) do
              def self.target_type
                :foo
              end
            end

            data = double('data')
            rule = rule_klass.new(:some_rule, :hoopty, data)
            expect(rule.target_type).to eq(:foo)
          end
        end
      end
    end

    context 'when not given initialization data' do
      context 'when given target type' do
        it 'assigns the data instance variable to nil' do
          rule = Togls::Rule.new(:some_rule, :hoopty, target_type: :foo)
          expect(rule.instance_variable_get(:@data)).to be_nil
        end

        it 'assigns the given target type to an instance variable' do
          rule = Togls::Rule.new(:some_rule, :hoopty, target_type: :some_target_type)
          expect(rule.instance_variable_get(:@target_type)).to eq(:some_target_type)
        end
      end

      context 'when not given target type' do
        context 'when rule type did not set target type' do
          it 'raises target type missing exception' do
            expect {
              rule = Togls::Rule.new(:some_rule, :hoopty)
            }.to raise_error(Togls::RuleMissingTargetType)
          end
        end

        context 'when rule type did set target type' do
          it 'return the rule types target type' do
            rule_klass = Class.new(Togls::Rule) do
              def self.target_type
                :foo
              end
            end

            rule = rule_klass.new(:some_rule, :hoopty)
            expect(rule.target_type).to eq(:foo)
          end
        end
      end
    end
  end

  describe "#run" do
    it "raises NotImplemented exception" do
      rule = Togls::Rule.new(:some_rule, :hoopty, target_type: :foo)
      expect { rule.run(double('feature key')) }
        .to raise_error(Togls::NotImplemented)
    end
  end

  describe "#id" do
    it "returns the string representation of the id" do
      rule = Togls::Rules::Boolean.new(:some_rule, :boolean, true)
      expect(rule.id).to eq(:some_rule)
    end
  end

  describe "#data" do
    it "returns the data it was initially initialized with" do
      rule = Togls::Rule.new(:some_rule, :hoopty, "test value", target_type: :foo)
      expect(rule.data).to eq("test value")
    end
  end

  describe '#type_id' do
    it 'returns the type_it it was initialized with' do
      rule = Togls::Rule.new(:some_rule, :hoopty, "test value", target_type: :foo)
      expect(rule.type_id).to eq(:hoopty)
    end
  end

  describe '#target_type' do
    context 'when the rule instance has a target type' do
      it 'returns the rule instances target type' do
        rule = Togls::Rule.new(:some_rule, :jacked, target_type: :hoopty)
        expect(rule.target_type).to eq(:hoopty)
      end
    end

    context 'when the rule instance has NO target type or is NOT_SET' do
      context 'when the rule type target type is NOT nil' do
        it 'returns the rule type target type' do
          rule_klass = Class.new(Togls::Rule) do
            def self.target_type
              :woot_woot
            end
          end

          rule = rule_klass.new(:some_rule, :jacked, 'some data')
          expect(rule.target_type).to eq(:woot_woot)
        end
      end
    end
  end

  describe '#missing_target_type?' do
    context 'when target type is set' do
      it 'returns false' do
        rule = Togls::Rule.new(:some_rule, :hoopty, target_type: :foo)
        expect(rule.missing_target_type?).to eq(false)
      end
    end

    context 'when target type is not set' do
      it 'returns true' do
        rule = Togls::Rule.new(:some_rule, :hoopty, target_type: :hoopty)
        rule.instance_variable_set(:@target_type, Togls::TargetTypes::NOT_SET)
        expect(rule.missing_target_type?).to eq(true)
      end
    end

    context 'when target type is nil' do
      it 'returns true' do
        rule = Togls::Rule.new(:some_rule, :hoopty, target_type: :hoopty)
        rule.instance_variable_set(:@target_type, nil)
        expect(rule.missing_target_type?).to eq(true)
      end
    end
  end
end
