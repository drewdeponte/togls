require 'spec_helper'

RSpec.describe Togls::Rules::Group do
  describe '.title' do
    it 'does not raise an error' do
      Togls::Rules::Group.title
    end
  end

  describe '.description' do
    it 'does not raise an error' do
      Togls::Rules::Group.description
    end
  end

  describe '.target_type' do
    it 'returns not set' do
      expect(Togls::Rules::Group.target_type).to eq(Togls::TargetTypes::NOT_SET)
    end
  end

  describe "#run" do
    context "when the target is included in the list" do
      it "returns true" do
        group = Togls::Rules::Group.new(:group, ["target"], target_type: :foo)
        expect(group.run(double('feature_key'), "target")).to eq(true)
      end
    end
  end
end
