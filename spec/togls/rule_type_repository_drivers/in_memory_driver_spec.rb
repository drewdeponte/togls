require 'spec_helper'

RSpec.describe Togls::RuleTypeRepositoryDrivers::InMemoryDriver do
  describe '.new' do
    subject { Togls::RuleTypeRepositoryDrivers::InMemoryDriver }

    it 'constructs an instance of an in-memory driver' do
      driver = subject.new
      expect(driver).
        to be_a(Togls::RuleTypeRepositoryDrivers::InMemoryDriver)
    end

    it 'assigns an empty hash for rule types' do
      driver = subject.new
      expect(driver.instance_variable_get(:@rule_types)).to eq({})
    end

    it 'assigns an empty hash for type_ids' do
      driver = subject.new
      expect(driver.instance_variable_get(:@type_ids)).to eq({})
    end
  end

  describe 'storing and retrieving' do
    it 'saves the storage payload and retrieves the klass and type_id' do
      klass = Class.new
      subject.store('some_key', klass.to_s)
      expect(subject.get_klass('some_key')).to eq(klass.to_s)
      expect(subject.get_type_id(klass.to_s)).to eq('some_key')
    end

    context 'when attempting to retrieve a non stored value' do
      it 'returns nil' do
        expect(subject.get_klass('non_existent_key')).to be_nil
        expect(subject.get_type_id('non_existent_klass_str')).to be_nil
      end
    end
  end
end
