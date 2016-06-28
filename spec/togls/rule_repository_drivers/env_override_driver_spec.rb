require 'spec_helper'

RSpec.describe Togls::RuleRepositoryDrivers::EnvOverrideDriver do
  describe '#initialize' do
    it 'constructs an instance' do
      res = Togls::RuleRepositoryDrivers::EnvOverrideDriver.new
      expect(res).to be_a(Togls::RuleRepositoryDrivers::EnvOverrideDriver)
    end
  end

  describe 'retrieving' do
    context 'when requesting a boolean rule with true' do
      it 'returns a boolean rule type with true' do
        rule_id = Togls::Rules::Boolean.new(:on, :boolean, true).id
        expect(subject.get(rule_id)).to eq({ 'id' => 'on', 'type_id' => 'boolean', 'data' => true, 'target_type' => Togls::TargetTypes::NONE.to_s })
      end
    end

    context 'when requesting a boolean rule with false' do
      it 'returns a boolean rule type with false' do
        rule_id = Togls::Rules::Boolean.new(:off, :boolean, false).id
        expect(subject.get(rule_id)).to eq({ 'id' => 'off', 'type_id' => 'boolean', 'data' => false, 'target_type' => Togls::TargetTypes::NONE.to_s })
      end
    end

    context 'when requesting any other type of rule' do
      it 'returns nil' do
        rule_id = 'aeuaoeuao'
        expect(subject.get(rule_id)).to be_nil
      end
    end
  end
end
