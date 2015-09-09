require_relative '../../../spec_helper'

describe Togls::Rules::Boolean do
  describe "#run" do
    it "returns the provided boolean value" do
      bool_rule = Togls::Rules::Boolean.new(true)
      expect(bool_rule.run(double)).to eq(true)
    end
  end
end
