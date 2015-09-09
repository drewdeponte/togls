require_relative '../../../spec_helper'

describe Togls::Rules::Group do
  describe "#run" do
    context "when the target is included in the list" do
      it "returns true" do
        group = Togls::Rules::Group.new(["target"])
        expect(group.run(double('feature_key'), "target")).to eq(true)
      end
    end
  end
end
