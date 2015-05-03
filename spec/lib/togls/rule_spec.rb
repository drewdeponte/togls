require_relative '../../spec_helper'

describe Togls::Rule do
  describe "#initialize" do
    it "stores the passed block" do
      b = Proc.new {}
      rule = Togls::Rule.new(&b)
      expect(rule.instance_variable_get(:@definition)).to eq(b)
    end
  end

  describe "#run" do
    it "runs the defined rule" do
      rule = Togls::Rule.new { "test value" }
      expect(rule.run).to eq("test value")
    end
  end
end
