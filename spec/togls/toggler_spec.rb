require 'spec_helper'

describe Togls::Toggler do
  let(:toggle_repository) { double('toggle repository') }
  let(:toggle) { double('toggle') }
  subject { Togls::Toggler.new(toggle_repository, toggle) }

  describe "#initialize" do
    it "constructs an instance of toggler" do
      toggle_repository = double('toggle repository')
      toggle = double('toggle')
      toggler = Togls::Toggler.new(toggle_repository, toggle)
      expect(toggler).to be_a(Togls::Toggler)
    end

    it "assigns the toggle repository" do
      toggle_repository = double('toggle repository')
      toggle = double('toggle')
      toggler = Togls::Toggler.new(toggle_repository, toggle)
      expect(toggler.instance_variable_get(:@toggle_repository)).to eq(toggle_repository)
    end

    it "assigns the toggle" do
      toggle_repository = double('toggle repository')
      toggle = double('toggle')
      toggler = Togls::Toggler.new(toggle_repository, toggle)
      expect(toggler.instance_variable_get(:@toggle)).to eq(toggle)
    end
  end

  describe "#on" do
    context "when the rule is nil" do
      it "creates a new rule" do
        allow(toggle_repository).to receive(:store)
        allow(toggle).to receive(:rule=)
        expect(Togls::Rules::Boolean).to receive(:new).once.and_return(Togls::Rules::Boolean.new)
        subject.on
      end
    end

    it "sets the toggle's rule to the new rule" do
      rule = Togls::Rules::Boolean.new
      toggle_repository = subject.instance_variable_get(:@toggle_repository)
      allow(toggle_repository).to receive(:store)
      allow(Togls::Rules::Boolean).to receive(:new).and_return(rule)
      toggle = subject.instance_variable_get(:@toggle)
      expect(toggle).to receive(:rule=).with(rule)
      subject.on
    end

    it "stores the updated toggle in the toggle repository" do
      toggle = subject.instance_variable_get(:@toggle)
      toggle_repository = subject.instance_variable_get(:@toggle_repository)
      allow(toggle).to receive(:rule=)
      expect(toggle_repository).to receive(:store).with(toggle)
      subject.on
    end

    it "returns its associated toggle" do
      toggle = subject.instance_variable_get(:@toggle)
      toggle_repository = subject.instance_variable_get(:@toggle_repository)
      allow(toggle_repository).to receive(:store)
      allow(toggle).to receive(:rule=)
      expect(subject.on).to eq(toggle)
    end
  end

  describe "#off" do
    context "when the rule is nil" do
      it "creates a new rule" do
        toggle = subject.instance_variable_get(:@toggle)
        toggle_repository = subject.instance_variable_get(:@toggle_repository)
        allow(toggle_repository).to receive(:store)
        allow(toggle).to receive(:rule=)
        expect(Togls::Rules::Boolean).to receive(:new).with(false)
        subject.off
      end
    end

    it "sets the toggle's rule" do
      rule = double('rule')
      toggle_repository = subject.instance_variable_get(:@toggle_repository)
      allow(toggle_repository).to receive(:store)
      allow(Togls::Rules::Boolean).to receive(:new).and_return(rule)
      toggle = subject.instance_variable_get(:@toggle)
      expect(toggle).to receive(:rule=).with(rule)
      subject.off
    end

    it "stores the updated toggle in the toggle repository" do
      toggle = subject.instance_variable_get(:@toggle)
      toggle_repository = subject.instance_variable_get(:@toggle_repository)
      allow(toggle).to receive(:rule=)
      expect(toggle_repository).to receive(:store).with(toggle)
      subject.off
    end

    it "returns its associated toggle" do
      toggle = subject.instance_variable_get(:@toggle)
      toggle_repository = subject.instance_variable_get(:@toggle_repository)
      allow(toggle_repository).to receive(:store)
      allow(toggle).to receive(:rule=)
      expect(subject.off).to eq(toggle)
    end
  end

end
