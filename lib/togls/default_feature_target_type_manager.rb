module Togls
  module DefaultFeatureTargetTypeManager
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def default_feature_target_type(target_type = nil)
        if target_type
          if @default_feature_target_type
            raise Togls::DefaultFeatureTargetTypeAlreadySet, 'the default feature target type has already been set'
          else
            @default_feature_target_type = target_type
          end
        else
          if @default_feature_target_type
            return @default_feature_target_type
          else
            return Togls::TargetTypes::NOT_SET
          end
        end
      end
    end
  end
end
