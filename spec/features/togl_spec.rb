require_relative '../spec_helper'

describe "Togl feature creation" do
  it "creates a new feature toggled on" do
    Togl.features do
      feature(:test).on
    end

    expect(Togl.feature(:test).on?).to eq(true)
  end

  it "creates a new feature toggled off" do
    Togl.features do
      feature(:test).off
    end

    expect(Togl.feature(:test).on?).to eq(false)
  end

  it "defaults to false when a feature is not defined" do
    allow(Togl.logger).to receive(:warn)
    Togl.features do
      feature(:test).on
    end

    expect(Togl.feature(:not_defined).on?).to eq(false)
  end

  it "creates a new feature with a rule" do
    Togl.features do
      rule = Togl::Rule.new { |v| !v }
      feature(:test).on(rule)
    end

    expect(Togl.feature(:test).on?(true)).to eq(false)
  end

  it "creates a new feature with a group" do
    Togl.features do
      rule = Togl::Rules::Group.new(["someone"])
      feature(:test).on(rule)
    end

    expect(Togl.feature(:test).on?("someone")).to eq(true)
    expect(Togl.feature(:test).on?("someone_else")).to eq(false)
  end
end
