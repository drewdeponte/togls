require 'spec_helper'

describe Togls::Rule do
  describe '.title' do
    it 'raises NotImplemented exception' do
      klass = Class.new(Togls::Rule)
      expect { klass.title }.to raise_error(Togls::NotImplemented)
    end
  end

  describe '.description' do
    it 'raises NotImplemented exception' do
      klass = Class.new(Togls::Rule)
      expect { klass.description }.to raise_error(Togls::NotImplemented)
    end
  end

  describe '.target_type' do
    it 'returns the default of :any' do
      klass = Class.new(Togls::Rule)
      expect(klass.target_type).to eq(Togls::TargetTypes::ANY)
    end
  end

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
    it "gets the sha1 of the rule klass with the initializer data" do
      rule = Togls::Rules::Boolean.new(true)
      expect(Togls::Helpers).to receive(:sha1).with(Togls::Rules::Boolean, true)
      rule.id
    end

    it "returns the sha1 it obtained" do
      rule = Togls::Rules::Boolean.new(true)
      sha1 = double('sha1')
      allow(Togls::Helpers).to receive(:sha1).and_return(sha1)
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
