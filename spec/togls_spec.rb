require 'spec_helper'

RSpec.describe "Togl" do
  describe 'set default feature target type' do
    it 'sets the default feature target type' do
      Togls.default_feature_target_type Togls::TargetTypes::NONE
    end
  end

  describe 'get the default feature target type' do
    it 'gets the default feature target type' do
      Togls.default_feature_target_type :foopty
      expect(Togls.default_feature_target_type).to eq(:foopty)
    end
  end

  describe 'registering rule types' do
    it 'registers the rule type' do
      rule_klass = Class.new(Togls::Rule) do
        def self.title
          'some title'
        end

        def self.description
          'some desc'
        end
      end

      Togls.rule_types do
        register(:some_rule_type, rule_klass)
      end
    end
  end

  describe 'get registered rule type class' do
    after do
      Object.send(:remove_const, :FooBarRule)
    end

    it 'returns the associated rule type class' do
      FooBarRule = Class.new(Togls::Rule) do
        def self.title
          'some title'
        end

        def self.description
          'some desc'
        end
      end

      Togls.rule_types do
        register(:test_rule_one, FooBarRule)
      end

      expect(Togls.rule_type(:test_rule_one)).to eq(FooBarRule)
    end

    context 'when registering the same rule type' do
      it 'raises an rule type uniqueness error' do
        FooBarRule = Class.new(Togls::Rule) do
          def self.title
            'some title'
          end

          def self.description
            'some desc'
          end
        end

        Togls.rule_types do
          register(:test_rule, FooBarRule)
        end

        expect {
          Togls.rule_types do
            register('test_rule', Integer)
          end
        }.to raise_error Togls::RuleTypeAlreadyDefined, "Rule Type identified by 'test_rule' has already been registered"
      end
    end

    context 'when the rule class has already been used in a type' do
      it 'raises an uniqueness error' do
        FooBarRule = Class.new(Togls::Rule) do
          def self.title
            'some title'
          end

          def self.description
            'some desc'
          end
        end

        Togls.rule_types do
          register(:rule_id, FooBarRule)
        end

        expect {
          Togls.rule_types do
            register('different_id', FooBarRule)
          end
        }.to raise_error Togls::RuleTypeAlreadyDefined, "Rule Type with class 'FooBarRule' has already been registered"
      end
    end
  end

  describe 'build rule' do
    after do
      Object.send(:remove_const, :FooBarRule)
    end

    it 'builds a rule instance from an abstract rule type and params' do
      FooBarRule = Class.new(Togls::Rule) do
        def self.title
          'some title'
        end

        def self.description
          'some desc'
        end
      end

      Togls.rule_types do
        register(:rule_id, FooBarRule)
      end

      data = double('some data')

      rule = Togls.rule(:rule_id, data, target_type: :some_target_type)
      expect(rule).to be_a(FooBarRule)
      expect(rule.data).to eq(data)
      expect(rule.target_type).to eq(:some_target_type)
    end
  end

  describe 'default rule types registered' do
    it 'makes the default rule types available' do
      klass = Class.new do
        include Togls::FeatureToggleRegistryManager
      end

      expect(klass.rule_type(:boolean)).to eq(Togls::Rules::Boolean)
      expect(klass.rule_type('boolean')).to eq(Togls::Rules::Boolean)
      expect(klass.rule_type(:group)).to eq(Togls::Rules::Group)
      expect(klass.rule_type('group')).to eq(Togls::Rules::Group)
    end
  end

  describe "defining release toggles" do
    context 'default feature target type NOT set' do
      context 'feature defined does not include target type' do
        it 'raise exception saying deafult feature target type has to be set or feature need a target type' do
          expect {
            Togls.release do
              feature(:test, "some human readable description").on
            end
          }.to raise_error(Togls::FeatureMissingTargetType)
        end
      end

      context 'feature defined does include target type' do
        it 'defines the feature' do
          expect {
            Togls.release do
              feature(:test, "some human readable description", target_type: :foo).on
            end
          }.not_to raise_error
        end
      end
    end

    context 'default feature target type set' do
      context 'feature defined does not include target type' do
        it 'defines the feature with the default feature target type' do
          Togls.default_feature_target_type :jacked

          Togls.release do
            feature(:foo, 'foo desc').on
          end

          expect(Togls.feature(:foo).feature.target_type).to eq(:jacked)
        end
      end

      context 'feature defined does include target type' do
        it 'defines the feature' do
          Togls.default_feature_target_type :jacked

          Togls.release do
            feature(:foo, 'foo desc', target_type: :hoopty).on
          end

          expect(Togls.feature(:foo).feature.target_type).to eq(:hoopty)
        end
      end
    end

    it "creates a new feature toggled on" do
      Togls.default_feature_target_type Togls::TargetTypes::NONE
      Togls.release do
        feature(:test, "some human readable description").on
      end

      expect(Togls.feature(:test).on?).to eq(true)
    end

    it "creates a new feature toggled off" do
      Togls.default_feature_target_type Togls::TargetTypes::NONE
      Togls.release do
        feature(:test, "some human readable description").off
      end

      expect(Togls.feature(:test).on?).to eq(false)
    end

    it "creates a new feature with a rule" do
      Togls.default_feature_target_type Togls::TargetTypes::NONE
      Togls.release do
        rule = Togls::Rules::Boolean.new(:boolean, false)
        feature(:test, "some human readable description").on(rule)
      end

      expect(Togls.feature(:test).on?).to eq(false)
    end

    it "creates a new feature with a group" do
      Togls.release do
        rule = Togls::Rules::Group.new(:group, ["someone"], target_type: :foo)
        feature(:test, "some human readable description", target_type: :foo).on(rule)
      end

      expect(Togls.feature(:test).on?("someone")).to eq(true)
      expect(Togls.feature(:test).on?("someone_else")).to eq(false)
    end

    context 'when using a custom rule that has a mismatched target type' do
      after do
        Object.send(:remove_const, :FooBarRule)
      end

      it 'raises an error' do
        FooBarRule = Class.new(Togls::Rule) do
          def self.title
            'some title'
          end

          def self.description
            'some desc'
          end

          def self.target_type
            :purple_person
          end
        end

        Togls.rule_types do
          register(:some_rule_type, FooBarRule)
        end

        some_rule = FooBarRule.new(:sometypeid)

        expect {
          Togls.release do
            feature(:hoopty, 'some hoopty description', target_type: :red_person).on(some_rule)
          end
        }.to raise_error Togls::RuleFeatureTargetTypeMismatch
      end
    end

    context 'when using a custom rule that has a matched target type' do
      after do
        Object.send(:remove_const, :FooBarRule)
      end

      it 'creates a new feature' do
        FooBarRule = Class.new(Togls::Rule) do
          def self.title
            'some title'
          end

          def self.description
            'some desc'
          end

          def self.target_type
            :purple_person
          end
        end

        Togls.rule_types do
          register(:some_rule_type, FooBarRule)
        end

        some_rule = FooBarRule.new(:sometypeid)

        Togls.release do
          feature(:hoopty, 'some hoopty description', target_type: :purple_person).on(some_rule)
        end
      end
    end

    context 'when redefining an existing feature' do
      it 'raises an already defined error' do
        Togls.default_feature_target_type :hoopty
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
      Togls.default_feature_target_type Togls::TargetTypes::NONE
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
      Togls.default_feature_target_type Togls::TargetTypes::NONE
      Togls.enable_test_mode
      Togls.release do
        feature(:foo, "some magic foo").on
      end

      expect(Togls.feature(:foo).on?).to eq(true)
    end
  end

  describe 'isolating toggles using test mode' do
    it 'stores, isolates, and recovers the toggles' do
      Togls.default_feature_target_type Togls::TargetTypes::NONE
      Togls.release do
        feature(:foo, 'some foo feature').on
      end

      Togls.test_mode do
        Togls.release do
          feature(:zar, 'some zar feature').on
        end

        Togls.feature(:foo).off

        expect(Togls.feature(:foo).on?).to eq(false)
        expect(Togls.feature(:zar).on?).to eq(true)
      end

      expect(Togls.feature(:foo).on?).to eq(true)
    end
  end

  describe "evaluating feature toggles" do
    it "asks a feature if it is on" do
      Togls.default_feature_target_type Togls::TargetTypes::NONE
      Togls.release do
        feature(:test, "some human readable description").on
      end

      expect(Togls.feature(:test).on?).to eq(true)
    end

    it "asks a feature if it is off" do
      Togls.default_feature_target_type Togls::TargetTypes::NONE
      Togls.release do
        feature(:test, "some human readable description").on
      end

      expect(Togls.feature(:test).off?).to eq(false)
    end

    it "defaults to false when a feature is not defined" do
      Togls.default_feature_target_type :hoopty
      allow(Togls.logger).to receive(:warn)
      Togls.release do
        feature(:test, "some human readable description").on
      end

      expect(Togls.feature(:not_defined).on?).to eq(false)
    end

    context "when a features rule can't properly be evaluated because of a mismatch" do
      after do
        Object.send(:remove_const, :AnotherRule)
        Object.send(:remove_const, :FooBarRule)
      end

      it 'reports the feature as being off' do
        FooBarRule = Class.new(Togls::Rule) do
          def self.title
            'some title'
          end

          def self.description
            'some desc'
          end

          def self.target_type
            :purple_person
          end

          def run(key, target = nil)
            # this shouldn't get returned
            true
          end
        end

        AnotherRule = Class.new(Togls::Rule) do
          def self.title
            'another title'
          end

          def self.description
            'another desc'
          end

          def self.target_type
            :red_person
          end

          def run(key, target = nil)
            # this shouldn't get returned
            true
          end
        end

        Togls.rule_types do
          register(:some_rule_type, FooBarRule)
          register(:another_rule_type, AnotherRule)
        end

        some_rule = FooBarRule.new(:sometypeid)
        a = AnotherRule.new(:someothertypeid)
        Togls.release do
          feature(:hoopty, 'some hoopty description', target_type: :purple_person).on(some_rule)
          feature(:doopty, 'some doopty description', target_type: :red_person).on(a)
        end

        toggle_repo = Togls.send(:release_toggle_registry).instance_variable_get(:@toggle_repository)
        rule_repo = toggle_repo.instance_variable_get(:@rule_repository)
        rule_in_memory_driver = rule_repo.instance_variable_get(:@drivers).first

        feature = Togls::Feature.new(:hoopty, 'some hoopty desc', :purple_person)
        toggle = Togls::Toggle.new(feature)
        toggle.instance_variable_set(:@rule, a)
        toggle_repo.store(toggle)

        expect(Togls.feature(:hoopty).instance_variable_get(:@toggle)).to be_a(Togls::RuleFeatureMismatchToggle)
        expect(Togls.feature(:hoopty).on?).to eq(false)
      end
    end

    context 'when the feature target type claims to send a target' do
      context 'when the feature evaluation sends a target' do
        it 'can be correctly evaluated' do
          numbers = Togls::Rules::Group.new(:group, [1,3,5], target_type: :number)
          Togls.release do
            feature(:foo, 'desc', target_type: :number).on(numbers)
          end

          expect {
            Togls.feature(:foo).on?(2)
          }.not_to raise_error

          expect {
            Togls.feature(:foo).off?(2)
          }.not_to raise_error
        end
      end

      context 'when the feature evaluation does NOT sends a target' do
        it 'raises an exception' do
          numbers = Togls::Rules::Group.new([1,3,5], target_type: :number)
          Togls.release do
            feature(:foo, 'desc', target_type: :number).on(numbers)
          end

          expect {
            Togls.feature(:foo).on?
          }.to raise_error Togls::EvaluationTargetMissing

          expect {
            Togls.feature(:foo).off?
          }.to raise_error Togls::EvaluationTargetMissing
        end
      end
    end

    context 'when the feature target type claims to NOT send a target' do
      context 'when the feature evaluation sends a target' do
        it 'raises an exception' do
          Togls.release do
            feature(:foo, 'desc', target_type: Togls::TargetTypes::NONE).on
          end

          expect {
            Togls.feature(:foo).on?(2)
          }.to raise_error Togls::UnexpectedEvaluationTarget

          expect {
            Togls.feature(:foo).off?(3)
          }.to raise_error Togls::UnexpectedEvaluationTarget
        end

        context 'when the evaluated feature is not defined' do
          it 'defaults to false' do
            allow(Togls.logger).to receive(:warn)
            Togls.release do
              feature(:test, "some human readable description", target_type: :hoopty).on
            end

            expect(Togls.feature(:not_defined).on?('aoeuoeau')).to eq(false)
          end
        end
      end

      context 'when the feature evaluation does NOT send a target' do
        it 'can be correctly evaluated' do
          Togls.release do
            feature(:foo, 'desc', target_type: Togls::TargetTypes::NONE).on
          end

          expect {
            Togls.feature(:foo).on?
          }.not_to raise_error

          expect {
            Togls.feature(:foo).off?
          }.not_to raise_error
        end
      end
    end

    context "when environment variable feature override is false" do
      after do
        ENV.delete("TOGLS_TEST")
      end

      it "feature reports being off" do
        Togls.default_feature_target_type Togls::TargetTypes::NONE
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
        Togls.default_feature_target_type  Togls::TargetTypes::NONE
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
        Togls.default_feature_target_type Togls::TargetTypes::NONE
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
    it "creates an isolated registry with a feature toggled off" do
      Togls.default_feature_target_type Togls::TargetTypes::NONE
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
