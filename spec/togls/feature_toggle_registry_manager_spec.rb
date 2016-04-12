require 'spec_helper'

describe Togls::FeatureToggleRegistryManager do
  let(:klass) { Class.new { include Togls::FeatureToggleRegistryManager } }

  describe '.rule_types' do
    context 'when rule_types have NOT been registered' do
      before do
        klass.instance_variable_set(:@rule_type_registry, nil)
        klass.instance_variable_set(:@rule_type_repository, nil)
      end

      it 'creates a new rule type regesitory in memory driver' do
        expect(Togls::RuleTypeRepositoryDrivers::InMemoryDriver).
          to receive(:new)
        klass.rule_types
      end

      it 'creates a new rule type repository' do
        in_memory_driver = double('rule type repo in memory driver')
        allow(Togls::RuleTypeRepositoryDrivers::InMemoryDriver).
          to receive(:new).and_return(in_memory_driver)
        expect(Togls::RuleTypeRepository).to receive(:new).
          with([in_memory_driver])
        klass.rule_types
      end

      it 'creates a new empty rule type registry' do
        rule_type_repository = double('rule type repository')
        allow(Togls::RuleTypeRepository).to receive(:new).
          and_return(rule_type_repository)
        expect(Togls::RuleTypeRegistry).to receive(:new).
          with(rule_type_repository)
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
        rule_type_registry = double('rule type registry')
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

  describe ".release" do
    context "when features have NOT been defined" do
      it "creates a new empty release toggle registry" do
        expect(Togls::ToggleRegistry).to receive(:new)
        klass.release
      end
    end

    context "when given a block" do
      it "expands the feature registry with a new block" do
        registry = klass.release
        b = Proc.new {}
        expect(registry).to receive(:expand).and_yield(&b)
        klass.release(&b)
      end
    end

    it "returns the release toggle registry" do
      release_toggle_registry = double('release toggle registry')
      allow(Togls::ToggleRegistry).to receive(:new).and_return(release_toggle_registry)
      expect(klass.release).to eq(release_toggle_registry)
    end
  end

  describe '.feature' do
    context "when features have NOT been defined" do
      it "creates a new empty release toggle registry" do
        klass.instance_variable_set(:@release_toggle_registry, nil)
        expect(Togls::ToggleRegistry).to receive(:new).and_call_original
        klass.feature("key")
      end
    end

    it "returns the release toggle identified by the key" do
      feature_registry = instance_double Togls::ToggleRegistry 
      klass.instance_variable_set(:@release_toggle_registry, feature_registry)
      expect(feature_registry).to receive(:get).with("key")
      klass.feature("key")
    end
  end

  describe ".logger" do
    it "memoizes a new logger instance" do
      logger = double('logger')
      klass.instance_variable_set(:@logger, nil)
      allow(Logger).to receive(:new).with(STDOUT).and_return(logger)
      expect(klass.logger).to eq(logger)
      expect(klass.logger).to eq(logger)
    end
  end

  describe '.enable_test_mode' do
    it 'stores the current release toggle registry' do
      test_registry = double('test registry')
      klass.instance_variable_set(:@release_toggle_registry, test_registry)
      klass.enable_test_mode
      expect(klass.instance_variable_get(:@previous_release_toggle_registry)).to\
        eq(test_registry)
    end

    it 'sets the release toggle registry to the test toggle registry' do
      test_registry = double('test registry')
      allow(klass).to receive(:test_toggle_registry).and_return(test_registry)
      klass.enable_test_mode
      expect(klass.instance_variable_get(:@release_toggle_registry)).to eq(test_registry)
    end
  end

  describe '.disable_test_mode' do
    it 'restores the release toggle registry to prev stored value' do
      test_registry = double('test registry')
      klass.instance_variable_set(:@previous_release_toggle_registry, test_registry)
      klass.disable_test_mode
      expect(klass.instance_variable_get(:@release_toggle_registry)).to\
        eq(test_registry)
    end
  end

  describe '.test_mode' do
    it 'enables test mode' do
      allow(klass).to receive(:disable_test_mode)
      expect(klass).to receive(:enable_test_mode)
      klass.test_mode {}
    end

    it 'yields the provided block' do
      allow(klass).to receive(:enable_test_mode)
      allow(klass).to receive(:disable_test_mode)
      expect { |b| klass.test_mode(&b) }.to yield_control
    end

    it 'disables test mode' do
      allow(klass).to receive(:enable_test_mode)
      expect(klass).to receive(:disable_test_mode)
      klass.test_mode {}
    end
  end
end
