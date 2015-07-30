require_relative '../spec_helper'

describe Togls do
  describe ".features" do
    context "when features have NOT been defined" do
      context "when given a block" do
        it "creates a new feature registry with passed block" do
          b = Proc.new {}
          expect(Togls::FeatureRegistry).to receive(:create).and_yield(&b)
          Togls.features(&b)
        end
      end
      
      context "when NOT given a block" do
        it "raises an error telling the user they must first define features" do
          expect { Togls.features }.to raise_error(Togls::NoFeaturesError)
        end
      end
    end

    context "when features HAVE been defined" do
      before do
        Togls.features do
          feature(:test1, "test1 readable description").on
          feature(:test2, "test2 readable description").off
          feature(:test3, "test3 readable description")
        end
      end

      context "when given a block" do
        it "replaces the feature registry with a new feature registry" do
          b = Proc.new {}
          expect(Togls::FeatureRegistry).to receive(:create).and_yield(&b)
          Togls.features(&b)
        end
      end

      context "when NOT given a block" do
        it "returns hash of feature objects identified by their key" do
          features = Togls.features
          expect(features[:test1].description).to eq("test1 readable description")
          expect(features[:test2].description).to eq("test2 readable description")
          expect(features[:test3].description).to eq("test3 readable description")
        end
      end
    end
  end

  describe ".feature" do
    it "returns the feature identified by the key" do
      feature = double('feature')
      feature_registry = Togls::FeatureRegistry.new(Togls::Rules::Boolean)
      feature_registry.instance_variable_set(:@registry, {key: feature})
      allow(feature_registry).to receive(:get).with(:key).and_return(feature)
      Togls.instance_variable_set(:@feature_registry, feature_registry)
      expect(Togls.feature(:key)).to eq(feature)
    end
  end

  describe ".logger" do
    it "memoizes a new logger instance" do
      logger = double('logger')
      Togls.instance_variable_set(:@logger, nil)
      allow(Logger).to receive(:new).with(STDOUT).and_return(logger)
      expect(Togls.logger).to eq(logger)
      expect(Togls.logger).to eq(logger)
    end
  end
end
