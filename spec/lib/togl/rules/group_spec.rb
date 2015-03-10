require 'spec_helper'

describe Togl::Rules::Group do
  describe "#initialize" do
    it "stores the passed list" do
      list = double('list')
      group = Togl::Rules::Group.new(list)
      expect(group.instance_variable_get(:@list)).to eq(list)
    end
  end

  describe "#run" do
    context "when the target is included in the list" do
      it "returns true" do
        group = Togl::Rules::Group.new(["target"])
        expect(group.run("target")).to eq(true)
      end
    end
  end
end
