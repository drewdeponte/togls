# ChangeLog

The following are lists of the notable changes included with each release.
This is intended to help keep people informed about notable changes between
versions, as well as provide a rough history.

#### Next Release

* Rename var in `FeatureRegistry.create` avoid confusion with overloaded name
* Make default boolean rule class configurable
* Add `Togls::Rules::BooleanEnvOverride` to allow environment based overrides
* Add Provided Rules Reference to README.md

#### v1.0.0

* Require human readable description to define a feature toggle
* Add rake task that outputs all the feature toggles states (on, off, ? -
  unknown due to Compex Rule), keys, and human readable descritpions

#### v0.1.0

* Add concept of Groups as a provided rule
* Add concept of Rules and Custom Rules, allowing users to have more dynamic
  feature toggles
* Add basic feature toggles able to be switched on/off
