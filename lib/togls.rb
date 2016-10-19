require 'optional_logger'
require 'togls/version'
require 'togls/errors'
require 'togls/helpers'
require 'togls/target_types'
require 'togls/toggle_repository_drivers'
require 'togls/toggle_repository_drivers/in_memory_driver'
require 'togls/toggle_repository_drivers/env_override_driver'
require 'togls/feature_repository_drivers'
require 'togls/feature_repository_drivers/in_memory_driver'
require 'togls/rule_repository_drivers'
require 'togls/rule_repository_drivers/in_memory_driver'
require 'togls/rule_repository_drivers/env_override_driver'
require 'togls/rule_type_repository_drivers'
require 'togls/rule_type_repository_drivers/in_memory_driver'
require 'togls/toggler'
require 'togls/rule_type_repository'
require 'togls/rule_type_registry'
require 'togls/toggle_registry'
require 'togls/feature_repository'
require 'togls/rule_repository'
require 'togls/toggle_repository'
require 'togls/feature'
require 'togls/toggle'
require 'togls/null_toggle'
require 'togls/rule'
require 'togls/rules'
require 'togls/rule_manager'
require 'togls/feature_toggle_registry_manager'
require 'togls/default_feature_target_type_manager'

# Togls
#
# Togls is the primary interface to the out of the box toggle registry. It is
# the namespace the DSL is exposed under.
module Togls
  include OptionalLogger::LoggerManagement
  include RuleManager
  include FeatureToggleRegistryManager
  include DefaultFeatureTargetTypeManager
end
