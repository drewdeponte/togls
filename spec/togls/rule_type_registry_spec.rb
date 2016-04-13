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
    let(:rule_klass) { Class.new(Togls::Rule) }

    it 'verifies the uniqueness of the rule' do
      allow(rule_type_repository).to receive(:store)
      expect(subject).to receive(:verify_uniqueness_of_rule_type).with(:some_type_id)
      subject.register(:some_type_id, rule_klass)
    end

    it 'stores a rule type in a the rule type repository' do
      allow(subject).to receive(:verify_uniqueness_of_rule_type)
      expect(rule_type_repository).to receive(:store).
        with(:some_rule_type, rule_klass)
      subject.register(:some_rule_type, rule_klass)
    end
  end

  describe '#verify_uniqueness_of_rule_type' do
    context 'when the rule type exists in the registry' do
      it 'raises an error' do
        allow(rule_type_repository).to receive(:include?).and_return(true)
        expect {
          subject.verify_uniqueness_of_rule_type(:type_id)
        }.to raise_error Togls::RuleTypeAlreadyDefined,
          "Rule Type identified by 'type_id' has already been registered"
      end
    end

    context 'when the rule type does NOT exist in the registry' do
      it 'does not raise an error' do
        allow(rule_type_repository).to receive(:include?).and_return(false)
        expect {
          subject.verify_uniqueness_of_rule_type(:type_id)
        }.not_to raise_error
      end
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
