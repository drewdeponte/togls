require 'spec_helper'

describe Togls::RuleRepositoryDrivers::EnvOverrideDriver do
  describe '#initialize' do
    it 'constructs an instance' do
      res = Togls::RuleRepositoryDrivers::EnvOverrideDriver.new
      expect(res).to be_a(Togls::RuleRepositoryDrivers::EnvOverrideDriver)
    end
  end

  describe 'retrieving' do
    context 'when requesting a boolean rule with true' do
      it 'returns a boolean rule type with true' do
        rule_id = Togls::Helpers.sha1(Togls::Rules::Boolean, true)
        expect(subject.get(rule_id)).to eq({ "klass" => Togls::Rules::Boolean, "data" => true })
      end
    end

    context 'when requesting a boolean rule with false' do
      it 'returns a boolean rule type with false' do
        rule_id = Togls::Helpers.sha1(Togls::Rules::Boolean, false)
        expect(subject.get(rule_id)).to eq({ "klass" => Togls::Rules::Boolean, "data" => false })
      end
    end

    context 'when requesting any other type of rule' do
      it 'returns nil' do
        rule_id = Togls::Helpers.sha1(Togls::Rule, nil)
        expect(subject.get(rule_id)).to be_nil
      end
    end
  end
end
