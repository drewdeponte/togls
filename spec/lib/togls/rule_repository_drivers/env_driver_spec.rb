require 'spec_helper'

describe Togls::RuleRepositoryDrivers::EnvDriver do
  describe "#initialize" do
    it "constructs an instance of env driver" do
      expect(subject).to be_a(Togls::RuleRepositoryDrivers::EnvDriver)
    end
  end

  # describe "#store" do
  #   context "when given a toggle id and toggle data" do
  #     it "passively pretends to persist the toggle data" do
  #       subject.store('badges', { "klass" => Togls::Rules::Boolean, "rule_id" => true })
  #     end
  #   end
  # end

  # describe "#get" do
  #   context "when given a rule id" do
  #     it "fetches the rule data" do
  #       expect(ENV).to receive(:fetch).with("TOGLS_badges"
  #       subject.get('badges')
  #     end
  #     it "returns the rule data"
  #   end
  # end
end
