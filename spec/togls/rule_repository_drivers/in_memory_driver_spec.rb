require 'spec_helper'

describe Togls::RuleRepositoryDrivers::InMemoryDriver do
  describe "#initialize" do
    it "constructs an instance" do
      res = Togls::RuleRepositoryDrivers::InMemoryDriver.new
      expect(res).to be_a(Togls::RuleRepositoryDrivers::InMemoryDriver)
    end

    it "assigns an empty hash for rules" do
      expect(subject.instance_variable_get(:@rules)).to eq({})
    end
  end

  describe "storing and retrieving" do
    it "saves the storage payload and retrieves it" do
      subject.store('aeuaoeuoa2342eau', { "klass" => Togls::Rule, "data" => true })
      expect(subject.get('aeuaoeuoa2342eau')).to eq({ "klass" => Togls::Rule, "data" => true })
    end

    context 'when attempting to retrieve a non stored value' do
      it 'returns nil' do
        expect(subject.get('non_existent_key')).to be_nil
      end
    end
  end
end
