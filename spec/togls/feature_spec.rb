require 'spec_helper'

describe Togls::Feature do
  subject { Togls::Feature.new(:key, "some description") }

  describe "#initialize" do
    it "assigns the passed key" do
      expect(subject.key).to eq("key")
    end

    it "assigns the description" do
      expect(subject.description).to eq("some description")
    end
  end

  describe "#description" do
    it "returns the description" do
      expect(subject.description).to eq("some description")
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
