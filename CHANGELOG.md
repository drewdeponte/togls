# ChangeLog

The following are lists of the notable changes included with each release.
This is intended to help keep people informed about notable changes between
versions, as well as provide a rough history. Each item is prefixed with
one of the following labels: `Added`, `Changed`, `Deprecated`,
`Removed`, `Fixed`, `Security`. We also use [Semantic
Versioning](http://semver.org) to manage the versions of this gem so
that you can set version constraints properly.

#### [Unreleased] - now

* `Changed`: driver construction to RegistryManager
  ([#56](https://github.com/codebreakdown/togls/issues/56))
* `Removed`: `TestToggleRegistry`
  ([#56](https://github.com/codebreakdown/togls/issues/56))
* `Changed`: `ReleaseToggleRegistry` to `ToggleRegistry`
  ([#56](https://github.com/codebreakdown/togls/issues/56))
* `Removed`: `features` rake task
  ([#48](https://github.com/codebreakdown/togls/issues/48))
* `Added`: `test_mode` block style method
  ([#44](https://github.com/codebreakdown/togls/issues/44))
* `Changed`: `Togls.features` to `Togls.release`
  ([#38](https://github.com/codebreakdown/togls/issues/38))
* `Changed`: Renamed `FeatureToggleRegistry` to `ReleaseToggleRegistry`
  ([#41](https://github.com/codebreakdown/togls/issues/41))
* `Added`: `FeatureToggleRegistryManager` methods, `enable_test_mode` &
  `disable_test_mode`
* `Removed`: `features=` setter
* `Changed`: `FeatureRepository` moved from `Registry` to `RegistryManager` 
  ([#40](https://github.com/codebreakdown/togls/issues/40))
* `Removed`: `FeatureToggleRegistry.create` and `TestToggleRegistry.create`
* `Changed`: `ReleaseToggleRegistryManager` to `FeatureToggleRegistryManager`
* `Added`: Base Error class for Togls exceptions
  ([#39](https://github.com/codebreakdown/togls/issues/39))
* `Added`: Exception for when a feature has already been defined in the feature
  repository
  ([#42](https://github.com/codebreakdown/togls/issues/42))

#### [v2.2.1] - 2016-03-24

* `Added`: in-memory driver `set`, `get`, `all` Marshaling to correct a threading
  reference based collision.
  ([#35](https://github.com/codebreakdown/togls/issues/35))

#### [v2.2.0] - 2016-03-04

* `Changed`: Togls to be thread-safe
* `Added`: `Togls::TestToggleRegistry` class for initializing test state
* `Added`: ability to create additional toggle registries

#### [v2.1.1] - 2015-12-14

* `Fixed`: env variable override wasn't falling through to in
  code defined memory value.
  ([#24](https://github.com/codebreakdown/togls/issues/24))

#### [v2.1.0] - 2015-11-24

* `Fixed`: exceptions happened on evaluation after setting
  `Togls.features = nil`
  ([#19](https://github.com/codebreakdown/togls/issues/19))

#### [v2.0.0] - 2015-11-23

* `Added`: ability to create empty feature toggle set via `Togls.features`
* `Added`: toggle definition expansion with multiple `Togls.features` blocks
* `Added`: set FeatureToggleRegistry instance, `Togls.features = toggle_registry`
* `Changed`: `Togls.features` to return FeatureToggleRegistry instance
  rather than an Array of Toggle objects.

#### [v1.1.0] - 2015-11-17

* `Added`: `off?` method for asking if a defined feature is off
* `Added`: feature toggle overrides
* `Changed`: Architecture to support concept of repositories and datastores allowing
  further growth in the future

#### [v1.0.0] - 2015-05-19

* `Changed`: to require human readable description to define a feature toggle
* `Added`: rake task that outputs all the feature toggles states (on, off, ? -
  unknown due to Compex Rule), keys, and human readable descritpions

#### [v0.1.0] - 2015-05-03

* `Added`: concept of Groups as a provided rule
* `Added`: concept of Rules and Custom Rules, allowing users to have more dynamic
  feature toggles
* `Added`: basic feature toggles able to be switched on/off

[Unreleased]: https://github.com/codebreakdown/togls/compare/v2.2.1...HEAD
[v2.2.1]: https://github.com/codebreakdown/togls/compare/v2.2.0...v2.2.1
[v2.2.0]: https://github.com/codebreakdown/togls/compare/v2.1.1...v2.2.0
[v2.1.1]: https://github.com/codebreakdown/togls/compare/v2.1.0...v2.1.1
[v2.1.0]: https://github.com/codebreakdown/togls/compare/v2.0.0...v2.1.0
[v2.0.0]: https://github.com/codebreakdown/togls/compare/v1.1.0...v2.0.0
[v1.1.0]: https://github.com/codebreakdown/togls/compare/v1.0.0...v1.1.0
[v1.0.0]: https://github.com/codebreakdown/togls/compare/v0.1.0...v1.0.0
[v0.1.0]: https://github.com/codebreakdown/togls/compare/0fa2feb...v0.1.0
