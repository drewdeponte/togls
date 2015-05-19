require_relative '../../../spec_helper'

describe Togls::Rules::Boolean do
  describe "#initialize" do
    it "stores the passed boolean" do
      bool = double('bool')
      group = Togls::Rules::Boolean.new(bool)
      expect(group.instance_variable_get(:@bool)).to eq(bool)
    end
  end

  describe "#run" do
    it "returns the provided boolean value" do
      bool_rule = Togls::Rules::Boolean.new(true)
      expect(bool_rule.run).to eq(true)
    end
  end
end
