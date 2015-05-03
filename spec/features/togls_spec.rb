require_relative '../spec_helper'

describe "Togl feature creation" do
  it "creates a new feature toggled on" do
    Togls.features do
      feature(:test).on
    end

    expect(Togls.feature(:test).on?).to eq(true)
  end

  it "creates a new feature toggled off" do
    Togls.features do
      feature(:test).off
    end

    expect(Togls.feature(:test).on?).to eq(false)
  end

  it "defaults to false when a feature is not defined" do
    allow(Togls.logger).to receive(:warn)
    Togls.features do
      feature(:test).on
    end

    expect(Togls.feature(:not_defined).on?).to eq(false)
  end

  it "creates a new feature with a rule" do
    Togls.features do
      rule = Togls::Rule.new { |v| !v }
      feature(:test).on(rule)
    end

    expect(Togls.feature(:test).on?(true)).to eq(false)
  end

  it "creates a new feature with a group" do
    Togls.features do
      rule = Togls::Rules::Group.new(["someone"])
      feature(:test).on(rule)
    end

    expect(Togls.feature(:test).on?("someone")).to eq(true)
    expect(Togls.feature(:test).on?("someone_else")).to eq(false)
  end
end
