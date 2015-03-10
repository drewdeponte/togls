require "togl/version"
require "togl/feature_registry"
require "togl/feature"

module Togl
  def self.features(&features)
    @feature_registry = FeatureRegistry.create(&features)
  end
  
  def self.feature(key)
    @feature_registry.get(key)
  end
end


# class Group
#     def member?(key)
#     end
# end
#
# group = Togl::Group.new
# 
# Togl.features do
#     feature(:foo).on
#     feature(:foo).off
#     feature(:foo).on(group)
# end
# 
# group = Togl::Group.new
# group = Togl::LdapGroup.new
# group = Togl::ADGroup.new
# group = Togl::ArrayGroup.new
#
# Togl.feature(:foo).on?(user.email)
# Togl.report(user.email)
