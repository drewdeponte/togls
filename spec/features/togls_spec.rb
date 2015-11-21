require_relative '../spec_helper'

describe "Togl feature creation" do
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

describe "Togl inspection" do
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
end

describe "Togl reporting" do
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
