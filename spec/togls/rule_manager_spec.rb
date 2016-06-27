require 'spec_helper'

RSpec.describe Togls::RuleManager do
  let(:klass) { Class.new { include Togls::RuleManager } }

  describe '.rule_types' do
    context 'when rule_types have NOT been registered' do
      before do
        klass.instance_variable_set(:@rule_type_registry, nil)
        klass.instance_variable_set(:@rule_type_repository, nil)
      end

      it 'creates a new rule type regesitory in memory driver' do
        expect(Togls::RuleTypeRepositoryDrivers::InMemoryDriver).
          to receive(:new).and_return(Togls::RuleTypeRepositoryDrivers::InMemoryDriver.new)
        klass.rule_types
      end

      it 'creates a new rule type repository' do
        in_memory_driver = Togls::RuleTypeRepositoryDrivers::InMemoryDriver.new
        allow(Togls::RuleTypeRepositoryDrivers::InMemoryDriver).
          to receive(:new).and_return(in_memory_driver)
        expect(Togls::RuleTypeRepository).to receive(:new).
          with([in_memory_driver]).and_return(Togls::RuleTypeRepository.new([in_memory_driver]))
        klass.rule_types
      end

      it 'creates a new empty rule type registry' do
        rule_type_repository = double('rule type repository')
        rule_type_registry = double('rule type registry', register: nil)
        allow(Togls::RuleTypeRepository).to receive(:new).
          and_return(rule_type_repository)
        expect(Togls::RuleTypeRegistry).to receive(:new).
          with(rule_type_repository).and_return(rule_type_registry)
        klass.rule_types
      end

      context 'when given a block' do
        it 'expands the rule type registry with a new block' do
          registry = klass.rule_types
          b = Proc.new {}
          expect(registry).to receive(:expand).and_yield(&b)
          klass.rule_types(&b)
        end
      end

      it 'returns the rule type registry' do
        rule_type_registry = double('rule type registry', register: nil)
        allow(Togls::RuleTypeRegistry).to receive(:new).
          and_return(rule_type_registry)
        expect(klass.rule_types).to eq(rule_type_registry)
      end
    end

    context 'when rule_types HAVE been registered' do
      let(:rule_type_registry) { double('rule type registry') }

      before do
        klass.instance_variable_set(:@rule_type_registry,
                                    rule_type_registry)
      end

      it 'does NOT create a new empty rule type registry' do
        expect(Togls::RuleTypeRegistry).not_to receive(:new)
        klass.rule_types
      end

      context 'when given a block' do
        it 'expands the rule type registry with a new block' do
          registry = klass.rule_types
          b = Proc.new {}
          expect(registry).to receive(:expand).and_yield(&b)
          klass.rule_types(&b)
        end
      end

      context 'when NOT given a block' do
        it 'returns the rule type registry' do
          expect(klass.rule_types).to eq(rule_type_registry)
        end
      end
    end
  end

  describe '.rule_type' do
    it 'fetches the rule type class from the registry' do
      registry = klass.rule_types
      expect(registry).to receive(:get).with(:some_rule_type)
      klass.rule_type(:some_rule_type)
    end

    it 'returns the obtained rule type class' do
      registry = klass.rule_types
      rule_type_klass = double('rule type class')
      allow(registry).to receive(:get).and_return(rule_type_klass)
      expect(klass.rule_type(:some_rule_type)).to eq(rule_type_klass)
    end
  end
end
