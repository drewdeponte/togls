require 'spec_helper'

RSpec.describe Togls::Feature do
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

    context 'when constructed target_type NOT set' do
      it 'raises exception saying feature missing target type' do
        expect {
          Togls::Feature.new(:key, 'some description', Togls::TargetTypes::NOT_SET)
        }.to raise_error(Togls::FeatureMissingTargetType)
      end
    end
  end

  describe "#description" do
    it "returns the description" do
      expect(subject.description).to eq("some description")
    end
  end

  describe '#target_type' do
    context 'when the target type is NOT nil' do
      it 'returns the target_type' do
        expect(subject.target_type).to eq(:foo_target_type)
      end
    end

    context 'when the target type is nil' do
      subject { Togls::Feature.new(:key, 'some description', :oeueou) }

      it 'returns a not set target type' do
        subject.instance_variable_set(:@target_type, nil)
        expect(subject.target_type).to eq(Togls::TargetTypes::NOT_SET)
      end
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

  describe '#missing_target_type?' do
    context 'when target type is set' do
      it 'returns false' do
        feature = Togls::Feature.new(:foo, 'desc', :hoopty)
        expect(feature.missing_target_type?).to eq(false)
      end
    end

    context 'when target type is not set' do
      it 'returns true' do
        feature = Togls::Feature.new(:foo, 'desc', :faoeu)
        feature.instance_variable_set(:@target_type, Togls::TargetTypes::NOT_SET)
        expect(feature.missing_target_type?).to eq(true)
      end
    end

    context 'when target type is nil' do
      it 'returns true' do
        feature = Togls::Feature.new(:foo, 'desc', :faoeu)
        feature.instance_variable_set(:@target_type, nil)
        expect(feature.missing_target_type?).to eq(true)
      end
    end
  end
end
