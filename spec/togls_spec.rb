require 'spec_helper'

describe "Togl" do
  describe "defining release toggles" do
    it "creates a new feature toggled on" do
      Togls.release do
        feature(:test, "some human readable description").on
      end

      expect(Togls.feature(:test).on?).to eq(true)
    end

    it "creates a new feature toggled off" do
      Togls.release do
        feature(:test, "some human readable description").off
      end

      expect(Togls.feature(:test).on?).to eq(false)
    end

    it "creates a new feature with a rule" do
      Togls.release do
        rule = Togls::Rules::Boolean.new(false)
        feature(:test, "some human readable description").on(rule)
      end

      expect(Togls.feature(:test).on?(true)).to eq(false)
    end

    it "creates a new feature with a group" do
      Togls.release do
        rule = Togls::Rules::Group.new(["someone"])
        feature(:test, "some human readable description").on(rule)
      end

      expect(Togls.feature(:test).on?("someone")).to eq(true)
      expect(Togls.feature(:test).on?("someone_else")).to eq(false)
    end

    context 'when redefining an existing feature' do
      it 'raises an already defined error' do
        Togls.release do
          feature(:foo, 'some decription')
        end

        expect {
          Togls.release do
            feature(:foo, 'previously defined')
          end
        }.to raise_error Togls::FeatureAlreadyDefined
      end
    end
  end

  describe "expanding feature toggles" do
    it "creates a new feature toggled on while keeping the previously defined features" do
      Togls.release do
        feature(:test, "some human readable description").on
      end

      Togls.release do
        feature(:bar, "some fooo").on
      end

      expect(Togls.feature(:test).on?).to eq(true)
      expect(Togls.feature(:bar).on?).to eq(true)
    end
  end

  describe "set the feature toggle registry" do
    it "uses the specified feature toggle registry" do
      Togls.enable_test_mode
      Togls.release do
        feature(:foo, "some magic foo").on
      end

      expect(Togls.feature(:foo).on?).to eq(true)
    end
  end

  describe 'isolating toggles using test mode' do
    it 'stores, isolates, and recovers the toggles' do
      Togls.release do
        feature(:foo, 'some foo feature').on
      end

      Togls.test_mode do
        Togls.release do
          feature(:zar, 'some zar feature').on
        end

        expect(Togls.feature(:foo).on?).to eq(false)
        expect(Togls.feature(:zar).on?).to eq(true)
      end

      expect(Togls.feature(:foo).on?).to eq(true)
    end
  end

  describe "evaluating feature toggles" do
    it "asks a feature if it is on" do
      Togls.release do
        feature(:test, "some human readable description").on
      end

      expect(Togls.feature(:test).on?).to eq(true)
    end

    it "asks a feature if it is off" do
      Togls.release do
        feature(:test, "some human readable description").on
      end

      expect(Togls.feature(:test).off?).to eq(false)
    end

    it "defaults to false when a feature is not defined" do
      allow(Togls.logger).to receive(:warn)
      Togls.release do
        feature(:test, "some human readable description").on
      end

      expect(Togls.feature(:not_defined).on?).to eq(false)
    end

    context "when environment variable feature override is false" do
      after do
        ENV.delete("TOGLS_TEST")
      end

      it "feature reports being off" do
        Togls.release do
          feature(:test, "some human readable description").on
        end

        ENV["TOGLS_TEST"] = "false"

        expect(Togls.feature(:test).on?).to eq(false)
      end
    end

    context "when environment variable feature override is true" do
      after do
        ENV.delete("TOGLS_TEST")
      end

      it "feature reports being on" do
        Togls.release do
          feature(:test, "some human readable description").off
        end

        ENV["TOGLS_TEST"] = "true"

        expect(Togls.feature(:test).on?).to eq(true)
      end
    end

    context "when env variable feature override is other than true/false" do
      after do
        ENV.delete("TOGLS_TEST")
      end

      it "feature falls back to in memory store value" do
        Togls.release do
          feature(:test, "some human readable description").on
        end

        ENV["TOGLS_TEST"] = "aeuaoeuaoeuauaueoauaauoe"

        expect(Togls.feature(:test).on?).to eq(true)
      end
    end
  end

  describe "handeling errors" do
    it "has a base error for all Togl errors for rescuing" do
      foo = Class.new do
        def self.bar
          raise Togls::NoFeaturesError
        rescue Togls::Error => e
          return "it was rescued"
        end
      end
      expect(foo.bar).to eql "it was rescued"
    end
  end

  describe "defining feature toggles in additional registry" do
    it "creates an isolated registred with a feature toggled off" do
      Togls.release do
        feature(:test, "some human readable description").on
      end

      klass = Class.new do
        include Togls::FeatureToggleRegistryManager
      end

      klass.release do
        feature(:test, "some human readable description").off
      end

      expect(Togls.feature(:test).on?).to eq(true)
      expect(klass.feature(:test).on?).to eq(false)
    end
  end
end
