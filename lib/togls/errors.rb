module Togls
  class Error < StandardError; end
  class NoFeaturesError < Error; end
  class MissingDriver < Error; end
  class InvalidDriver < Error; end
  class NotImplemented < Error; end
  class FeatureAlreadyDefined < Error; end
  class RuleTypeAlreadyDefined < Error; end
  class RuleFeatureTargetTypeMismatch < Error; end
  class RuleMissingTargetType < Error; end
  class DefaultFeatureTargetTypeAlreadySet < Error; end
  class FeatureMissingTargetType < Error; end
  class EvaluationTargetMissing < Error; end
  class UnexpectedEvaluationTarget < Error; end
  class RepositoryFeatureDataInvalid < Error; end
end
