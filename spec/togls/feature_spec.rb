require 'spec_helper'

describe Togls::Feature do
  subject { Togls::Feature.new(:key, "some description", :foo_target_type) }

  describe "#initialize" do
    it "assigns the passed key" do
      expect(subject.key).to eq("key")
    end

    it "assigns the description" do
      expect(subject.description).to eq("some description")
    end

    it 'assigns the given target_type' do
      expect(subject.target_type).to eq(:foo_target_type)
    end

    context 'when constructed without a target_type' do
      subject { Togls::Feature.new(:key, 'some description') }

      it 'assigns the target_type to be not set' do
        expect(subject.target_type).to eq(Togls::TargetTypes::NOT_SET)
      end
    end
  end

  describe "#description" do
    it "returns the description" do
      expect(subject.description).to eq("some description")
    end
  end

  describe '#target_type' do
    it 'returns the target_type' do
      expect(subject.target_type).to eq(:foo_target_type)
    end
  end

  describe "#key" do
    it "returns the key of the feature" do
      expect(subject.key).to eq("key")
    end
  end

  describe "#id" do
    it "returns the key of the feature" do
      expect(subject.id).to eq("key")
    end
  end
end
