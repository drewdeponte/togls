require 'spec_helper'

describe Togl::Rule do
  describe "#initialize" do
    it "stores the passed block" do
      b = Proc.new {}
      rule = Togl::Rule.new(&b)
      expect(rule.instance_variable_get(:@definition)).to eq(b)
    end
  end

  describe "#run" do
    it "runs the defined rule" do
      rule = Togl::Rule.new { "test value" }
      expect(rule.run).to eq("test value")
    end
  end
end
