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
      expect(rule.run(double('feature key'))).to eq("test value")
    end
  end

  describe "#id" do
    it "return the hex sha1 of the rule klass with the initalizer data" do
      rule = Togls::Rules::Boolean.new(true)
      sha1 = Digest::SHA1.hexdigest("Togls::Rules::Booleantrue")
      expect(rule.id).to eq(sha1)
    end
  end
end
