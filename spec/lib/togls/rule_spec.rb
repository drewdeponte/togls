require_relative '../../spec_helper'

describe Togls::Rule do
  describe "#initialize" do
    it "assigns the given data to an instance variable" do
      data = double('data')
      rule = Togls::Rule.new(data)
      expect(rule.instance_variable_get(:@data)).to eq(data)
    end
  end

  describe "#run" do
    it "raises NotImplemented exception" do
      rule = Togls::Rule.new("test value")
      expect { rule.run(double('feature key')) }
        .to raise_error(Togls::NotImplemented)
    end
  end

  describe "#id" do
    it "return the hex sha1 of the rule klass with the initalizer data" do
      rule = Togls::Rules::Boolean.new(true)
      sha1 = Digest::SHA1.hexdigest("Togls::Rules::Boolean:true")
      expect(rule.id).to eq(sha1)
    end
  end

  describe "#data" do
    it "returns the data it was initially initialized with" do
      rule = Togls::Rule.new("test value")
      expect(rule.data).to eq("test value")
    end
  end
end
