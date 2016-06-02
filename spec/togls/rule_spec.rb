require 'spec_helper'

describe Togls::Rule do
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
    context 'when just given intialization data' do
      it 'assigns the given data to an instance variable' do
        data = double('data')
        rule = Togls::Rule.new(data)
        expect(rule.instance_variable_get(:@data)).to eq(data)
      end

      it 'assigns the target type instance variable to nil' do
        data = double('data')
        rule = Togls::Rule.new(data)
        expect(rule.instance_variable_get(:@target_type)).to eq(Togls::TargetTypes::NOT_SET)
      end
    end

    context 'when given initialization data and target_type' do
      it 'assigns the given data to an instance variable' do
        data = double('data')
        rule = Togls::Rule.new(data, target_type: :some_target_type)
        expect(rule.instance_variable_get(:@data)).to eq(data)
      end

      it 'assigns the given target type to an instance variable' do
        data = double('data')
        rule = Togls::Rule.new(data, target_type: :some_target_type)
        expect(rule.instance_variable_get(:@target_type)).to eq(:some_target_type)
      end
    end
  end

  describe "#run" do
    it "raises NotImplemented exception" do
      rule = Togls::Rule.new("test value")
      expect { rule.run(double('feature key')) }
        .to raise_error(Togls::NotImplemented)
    end
  end

  describe "#id" do
    it "gets the sha1 of the rule klass with the initializer data" do
      rule = Togls::Rules::Boolean.new(true)
      expect(Togls::Helpers).to receive(:sha1).with(Togls::Rules::Boolean, true)
      rule.id
    end

    it "returns the sha1 it obtained" do
      rule = Togls::Rules::Boolean.new(true)
      sha1 = double('sha1')
      allow(Togls::Helpers).to receive(:sha1).and_return(sha1)
      expect(rule.id).to eq(sha1)
    end
  end

  describe "#data" do
    it "returns the data it was initially initialized with" do
      rule = Togls::Rule.new("test value")
      expect(rule.data).to eq("test value")
    end
  end

  describe '#target_type' do
    context 'when the rule instance has a target type' do
      it 'returns the rule instances target type' do
        rule = Togls::Rule.new('some data', target_type: :hoopty)
        expect(rule.target_type).to eq(:hoopty)
      end
    end

    context 'when the rule instance has NO target type or is NOT_SET' do
      context 'the class target type is nil' do
        it 'returns the rule type target type' do
          rule_klass = Class.new(Togls::Rule) do
            def self.target_type
              nil
            end
          end

          rule = rule_klass.new('some data')
          expect(rule.target_type).to eq(Togls::TargetTypes::NOT_SET)
        end
      end

      context 'when the class target type is NOT nil' do
        it 'returns the rule type target type' do
          rule_klass = Class.new(Togls::Rule) do
            def self.target_type
              :woot_woot
            end
          end

          rule = rule_klass.new('some data')
          expect(rule.target_type).to eq(:woot_woot)
        end
      end
    end
  end
end
