require_relative '../../../spec_helper'

describe Togls::Rules::Group do
  describe "#initialize" do
    it "stores the passed list" do
      list = double('list')
      group = Togls::Rules::Group.new(list)
      expect(group.instance_variable_get(:@list)).to eq(list)
    end
  end

  describe "#run" do
    context "when the target is included in the list" do
      it "returns true" do
        group = Togls::Rules::Group.new(["target"])
        expect(group.run(double('feature_key'), "target")).to eq(true)
      end
    end
  end
end
