require 'spec_helper'

RSpec.describe Togls::DefaultFeatureTargetTypeManager do
  describe '#default_feature_target_type' do
    describe 'setting the default feature target type' do
      context 'when default feature target type has not been set' do
        it 'sets the default feature target type' do
          klass = Class.new do
            include Togls::DefaultFeatureTargetTypeManager
          end

          klass.default_feature_target_type Togls::TargetTypes::NONE
          expect(klass.instance_variable_get(:@default_feature_target_type)).to eq(Togls::TargetTypes::NONE)
        end
      end

      context 'when default feature target type has previously been set' do
        it 'raises an exception' do
          klass = Class.new do
            include Togls::DefaultFeatureTargetTypeManager
          end

          klass.default_feature_target_type Togls::TargetTypes::NONE
          expect {
            klass.default_feature_target_type Togls::TargetTypes::NONE
          }.to raise_error(Togls::DefaultFeatureTargetTypeAlreadySet)
        end
      end
    end

    describe 'getting the default feature target type' do
      context 'when already set' do
        it 'gets the default feature target type' do
          klass = Class.new do
            include Togls::DefaultFeatureTargetTypeManager
          end

          klass.default_feature_target_type Togls::TargetTypes::NONE
          expect(klass.default_feature_target_type).to eq(Togls::TargetTypes::NONE)
        end
      end

      context 'when not already set' do
        it 'returns NOT_SET' do
          klass = Class.new do
            include Togls::DefaultFeatureTargetTypeManager
          end

          expect(klass.default_feature_target_type).to eq(Togls::TargetTypes::NOT_SET)
        end
      end
    end
  end
end
