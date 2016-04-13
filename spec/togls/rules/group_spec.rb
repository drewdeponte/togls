require 'spec_helper'

describe Togls::Rules::Group do
  describe '.title' do
    it 'does not raise an error' do
      Togls::Rules::Boolean.title
    end
  end

  describe '.description' do
    it 'does not raise an error' do
      Togls::Rules::Boolean.description
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
