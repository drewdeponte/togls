require 'spec_helper'

describe "Togl" do
  describe "defining feature toggles" do
    it "creates a new feature toggled on" do
      Togls.features do
        feature(:test, "some human readable description").on
      end

      expect(Togls.feature(:test).on?).to eq(true)
    end

    it "creates a new feature toggled off" do
      Togls.features do
        feature(:test, "some human readable description").off
      end

      expect(Togls.feature(:test).on?).to eq(false)
    end

    it "creates a new feature with a rule" do
      Togls.features do
        rule = Togls::Rules::Boolean.new(false)
        feature(:test, "some human readable description").on(rule)
      end

      expect(Togls.feature(:test).on?(true)).to eq(false)
    end

    it "creates a new feature with a group" do
      Togls.features do
        rule = Togls::Rules::Group.new(["someone"])
        feature(:test, "some human readable description").on(rule)
      end

      expect(Togls.feature(:test).on?("someone")).to eq(true)
      expect(Togls.feature(:test).on?("someone_else")).to eq(false)
    end
  end

  describe "expanding feature toggles" do
    it "creates a new feature toggled on while keeping the previously defined features" do
      Togls.features do
        feature(:test, "some human readable description").on
      end

      Togls.features do
        feature(:bar, "some fooo").on
      end

      expect(Togls.feature(:test).on?).to eq(true)
      expect(Togls.feature(:bar).on?).to eq(true)
    end
  end

  describe "set the feature toggle registry" do
    it "uses the specified feature toggle registry" do
      Togls.features = Togls::TestToggleRegistry.new
      Togls.features do
        feature(:foo, "some magic foo").on
      end

      expect(Togls.feature(:foo).on?).to eq(true)
    end
  end

  describe "evaluating feature toggles" do
    it "asks a feature if it is on" do
      Togls.features do
        feature(:test, "some human readable description").on
      end

      expect(Togls.feature(:test).on?).to eq(true)
    end

    it "asks a feature if it is off" do
      Togls.features do
        feature(:test, "some human readable description").on
      end

      expect(Togls.feature(:test).off?).to eq(false)
    end

    it "defaults to false when a feature is not defined" do
      allow(Togls.logger).to receive(:warn)
      Togls.features do
        feature(:test, "some human readable description").on
      end

      expect(Togls.feature(:not_defined).on?).to eq(false)
    end

    context "when environment variable feature override is false" do
      after do
        ENV.delete("TOGLS_TEST")
      end

      it "feature reports being off" do
        Togls.features do
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
        Togls.features do
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
        Togls.features do
          feature(:test, "some human readable description").on
        end

        ENV["TOGLS_TEST"] = "aeuaoeuaoeuauaueoauaauoe"

        expect(Togls.feature(:test).on?).to eq(true)
      end
    end
  end

  describe "reviewing feature toggle" do
    it "outputs all the features" do
      Togls.features do
        feature(:test1, "test1 readable description").on
        feature(:test2, "test2 readable description").off
        feature(:test3, "test3 readable description")
        feature(:test4, "test4 readable description").on(Togls::Rules::Boolean.new(true))
      end

      require 'rake'
      load 'lib/tasks/togls.rake'

      expect { Rake::Task["togls:features"].invoke }.to output(%q{ on - test1 - test1 readable description
off - test2 - test2 readable description
off - test3 - test3 readable description
 on - test4 - test4 readable description
}).to_stdout
    end
  end

  describe "defining feature toggles in additional registry" do
    it "creates an isolated registred with a feature toggled off" do
      Togls.features do
        feature(:test, "some human readable description").on
      end

      klass = Class.new do
        include Togls::FeatureToggleRegistryManager
      end

      klass.features do
        feature(:test, "some human readable description").off
      end

      expect(Togls.feature(:test).on?).to eq(true)
      expect(klass.feature(:test).on?).to eq(false)
    end
  end
end
