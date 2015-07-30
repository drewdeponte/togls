require_relative '../../../spec_helper'

describe Togls::Rules::BooleanEnvOverride do
  describe "#initialize" do
    it "stores the passed boolean" do
      bool = double('bool')
      group = Togls::Rules::BooleanEnvOverride.new(bool, double)
      expect(group.instance_variable_get(:@bool)).to eq(bool)
    end

    it "stores the passed feature key" do
      feature_key = double('feature key')
      group = Togls::Rules::BooleanEnvOverride.new(double, feature_key)
      expect(group.instance_variable_get(:@feature_key)).to eq(feature_key)
    end
  end

  describe "#run" do
    context "when environment variable is NOT present" do
      it "returns the provided boolean value" do
        bool_rule = Togls::Rules::BooleanEnvOverride.new(true)
        expect(bool_rule.run).to eq(true)
      end
    end

    context "when environment variable IS present" do
      context "when environment variable equals 'true'" do
        after do
          ENV.delete("TOGLS_TEST_FEATURE_HOOPTY")
        end

        it "returns true" do
          ENV["TOGLS_TEST_FEATURE_HOOPTY"]="true"
          bool_rule = Togls::Rules::BooleanEnvOverride.new(false,
                                                           :test_feature_hoopty)
          expect(bool_rule.run).to eq(true)
        end
      end

      context "when environment variable does NOT equal 'true'" do
        after do
          ENV.delete("TOGLS_TEST_FEATURE_DOOPTY")
        end

        it "returns false" do
          ENV["TOGLS_TEST_FEATURE_DOOPTY"]="aeuoeuao"
          bool_rule = Togls::Rules::BooleanEnvOverride.new(false,
                                                           :test_feature_hoopty)
          expect(bool_rule.run).to eq(false)
        end
      end
    end
  end
end
