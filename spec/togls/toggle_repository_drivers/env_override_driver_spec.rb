require 'spec_helper'

RSpec.describe Togls::ToggleRepositoryDrivers::EnvOverrideDriver do
  describe "#initialize" do
    it "constructs an instance of env driver" do
      expect(subject).to be_a(Togls::ToggleRepositoryDrivers::EnvOverrideDriver)
    end
  end

  describe "#store" do
    context "when given a toggle id and toggle data" do
      it "passively pretends to persist the toggle data" do
        subject.store('badges', { "feature_id" => "badges", "rule_id" => "aeouaeoao23442aoeu24" })
      end
    end
  end

  describe "#get" do
    context "when environment toggle isn't set" do
      before do
        ENV.delete("TOGLS_SOME_TOGGLE_ID")
      end

      it "returns nil" do
        expect(subject.get("some_toggle_id")).to be_nil
      end
    end

    context "when environment toggle IS set" do
      context "when it is true" do
        before do
          ENV["TOGLS_SOME_TOGGLE_ID"] = "true"
        end

        it "returns Togls::Rules::Boolean true toggle data" do
          expect(subject.get("some_toggle_id")).to eq({ "feature_id" => "some_toggle_id",
                     "rule_id" => Togls::Rules::Boolean.new(:boolean, true).id })
        end
      end

      context "when it is false" do
        before do
          ENV["TOGLS_SOME_TOGGLE_ID"] = "false"
        end

        it "returns Togls::Rules::Boolean false toggle data" do
          expect(subject.get("some_toggle_id")).to eq({ "feature_id" => "some_toggle_id",
                     "rule_id" => Togls::Rules::Boolean.new(:boolean, false).id })
        end
      end

      context "when it is not true/false" do
        before do
          ENV["TOGLS_SOME_TOGGLE_ID"] = "aeuaeouaoeuaeuaou"
        end

        it "returns nil" do
          expect(subject.get("some_toggle_id")).to be_nil
        end
      end
    end
  end
end
