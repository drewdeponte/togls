require 'spec_helper'

RSpec.describe Togls::RuleTypeRegistry do
  let(:rule_type_repository) { double('rule type repository') }
  subject { Togls::RuleTypeRegistry.new(rule_type_repository) }

  describe '.new' do
    subject { Togls::RuleTypeRegistry }

    it 'constructs a rule type registry' do
      rule_type_repository = double('rule type repoository')
      subject.new(rule_type_repository)
    end

    it 'assigns the provide rule type repository' do
      rule_type_repository = double('rule type repoository')
      rule_type_registry = subject.new(rule_type_repository)
      expect(rule_type_registry.instance_variable_get(
        :@rule_type_repository)).to eq(rule_type_repository)
    end
  end

  describe '#expand' do
    it 'instance evals the provided block' do
      expect(subject).to receive(:instance_eval)
      subject.expand do
        register(:bar, Class.new)
      end
    end

    it 'returns the rule type registry' do
      block = Proc.new {}
      expect(subject.expand(&block)).to eq(subject)
    end
  end

  describe '#register' do
    it 'stores a rule type in a the rule type repository' do
      rule_klass = Class.new(Togls::Rule)
      expect(rule_type_repository).to receive(:store).
        with(:some_rule_type, rule_klass)
      subject.register(:some_rule_type, rule_klass)
    end
  end

  describe '#get' do
    it 'gets a rule type from the rule type repository' do
      rule_klass = Class.new(Togls::Rule)
      expect(rule_type_repository).to receive(:get_klass).
        with(:some_rule_type)
      subject.get(:some_rule_type)
    end

    it 'returns the obtained klass from rule type repository' do
      rule_klass = Class.new(Togls::Rule)
      allow(rule_type_repository).to receive(:get_klass).
        with(:some_rule_type).and_return(rule_klass)
      expect(subject.get(:some_rule_type)).to eq(rule_klass)
    end
  end
end
