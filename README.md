[![Gem Version](https://badge.fury.io/rb/togls.svg)](http://badge.fury.io/rb/togls)
[![Build Status](https://travis-ci.org/codebreakdown/togls.svg?branch=master)](https://travis-ci.org/codebreakdown/togls)
[![Code Climate](https://codeclimate.com/github/codebreakdown/togls/badges/gpa.svg)](https://codeclimate.com/github/codebreakdown/togls)
[![Test Coverage](https://codeclimate.com/github/codebreakdown/togls/badges/coverage.svg)](https://codeclimate.com/github/codebreakdown/togls/coverage)
[![Dependency Status](https://gemnasium.com/codebreakdown/togls.svg)](https://gemnasium.com/codebreakdown/togls)
[![Inline docs](http://inch-ci.org/github/codebreakdown/togls.svg?branch=master)](http://inch-ci.org/github/codebreakdown/togls)

# Togls

A lightweight, simple, and yet extremely flexible feature toggle library
for Ruby. It prides itself on being designed in such a manner that it is
extremely flexible and yet still provides a simple, clear, and
meaningful interface.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'togls'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install togls

## Basic Usage

At the core `togls` is primarily used by performing two distinct
actions.

1. Defining Feature Toggles
2. Evaluating Feature Toggles

### Defining Feature Toggles

In order to use `togls`, you first have to define some feature toggles.
It is highly recommended that you define your feature toggles in their
own file. If you are using `togls` in a Rails project we recommend
putting it in `config/initializers/togls_features.rb`. If you are using
`togls` in a generic Ruby project you can locate it wherever you like.
However, the feature definitions **must** be loaded before they can be
evaluated.

The following, `config/initializers/togls_features.rb`, is an example of
how one would define some basic feature toggles.

```ruby
Togls.release do
  # Set this feature to always be on
  feature(:pop_up_login_form, "use pop up login instead of normal login").on

  # Set this feature to always be off
  feature(:send_follup_email, "send the follow up email").off
end
```

The above defined feature toggles would use default feature target type. If we
wanted to define them explicitly with other target types it would like as
follows.

```ruby
Togls.release do
  # Set this feature to always be on
  feature(:pop_up_login_form, "use pop up login instead of normal login", :user_id).on

  # Set this feature to always be off
  feature(:send_follup_email, "send the follow up email", :user_email_address).off
end
```

### Evaluating Feature Toggles

Once you have defined your feature toggles. The next thing you would
likely want to do is conditionally control something based on them. The
following are a few examples of how you would do this given the feature
definitions provided above.

```ruby
if Togls.feature(:pop_up_login_form).on?
  # Use pop up login form
else
  # Use normal non-pop up login form
end

...

if Togls.feature(:send_follup_email).on?
  # send the follow up email
end
```

**Note:** Feature toggles that are evaluated but have **not** been
defined will default to **off**.

The above two feature toggles evaluated are written as if the feature toggle has
a target type of `Togls::TargetTypes::NONE`. If the feature toggles had a
specific target type and they were evaluted as shown above an exception would be
raised notifying you that they expect an entity of that type as the target for
evaluation. To better match the explicit target type example from Defining
Feature Toggles it would look something like the following.


```ruby
if Togls.feature(:pop_up_login_form).on?(current_user.id)
  # Use pop up login form
else
  # Use normal non-pop up login form
end

...

if Togls.feature(:send_follup_email).on?(current_user.email)
  # send the follow up email
end
```

### Override Feature Toggles

Toggles can be overriden using environment variables following the
naming scheme provided below. This is especially useful when wanting to
change state of toggles within your development environment, without
altering the codified default state.

The naming scheme for overriding toggles is simply the key of the
feature toggle in all caps with `TOGLS_` prefixed to it. For example if
we had the following feature toggle defined.

```ruby
Togls.release do
  # Set this feature to always be on
  feature(:pop_up_login_form, "use pop up login instead of normal login").on
end
```

We could override this by setting the value of the
`TOGLS_POP_UP_LOGIN_FORM` environment variable to `"false"`. If you want
to override a feature toggle to an on state you can set the
`TOGLS_POP_UP_LOGIN_FORM` environment variable to `"true"`.

**Note:** This feature is explicitly designed for use in your development
environment. If you use this feature in other environments (qa, staging,
production, etc.) it may not behave as you expect.

### Toggle Features based on Group Membership

`togls` provides out of the box support for toggling features based on
group membership. This basically allows you to have a feature **on** for
members of a defined group and **off** for non-members. This can be
extremely useful if you want to enable features for a small alpha test
group for example.

**Note:** This is implemented using `togls` extremely robust [custom
rules](https://github.com/codebreakdown/togls/wiki/Custom-Rule-Types-&-Rules) system.
The following example is just one of the many powerful things you can do
with `togls` and [custom
rules](https://github.com/codebreakdown/togls/wiki/Custom-Rule-Types-&-Rules).

#### Defining Group based Feature Toggles

The following is an example definition of a feature that toggles on
based on group membership.

```ruby
# Create a group rule so the feature is on if the user is a member of
# the group.
alpha_testers = Togls.rule(:group, ["user1@email.com", "user2@example.com"], target_type: :user_email_address)

Togls.release do
  feature(:new_contact_form, "use new contact form", target_type: :user_email_address).on(alpha_testers)
end
```

The above is really broken down into two steps.

1. Construct the
   [rule](https://github.com/codebreakdown/togls/wiki/Provided-Rules-Reference)
   you want to use
2. Define the feature toggle and pass the
   [rule](https://github.com/codebreakdown/togls/wiki/Provided-Rules-Reference)
   to its `on()` method

In the above example we construct an instance of the
[Togls::Rules::Group](https://github.com/codebreakdown/togls/wiki/Provided-Rules-Reference#toglsrulesgroup)
rule, passing it the list of alpha tester email addresses.
[Togls::Rules::Group](https://github.com/codebreakdown/togls/wiki/Provided-Rules-Reference#toglsrulesgroup)
is a rule that `togls` provides to make your life a bit simpler.

Then we define a feature, `:new_contact_form`, that will be on for
alpha testers and off for people that don't fall within that group.

#### Evaluating Group based Feature Toggles

Group based rules are evaluated by using the `on?` method. However, in
this case we have to pass the `on?` method the `target`. The `target` in
this case is the email address of the current user. The target is the
identifier that you want to check if it belongs to the group or not.

```ruby
if Togls.feature(:new_contact_form).on?(current_user.email)
  # Use new contact form
else
  # Use old contact form
end
```

**Note:** In the above example I reference `current_user.email`. This is
not something that `togls` provides. It is simply a common way for
Ruby/Rails applications to implement access to the concept of the current user.

#### Groups of Anything

You could just as easily have used user ids instead of email addresses
in the example above and it would look something like the following:

```ruby
# Create a group rule so the feature is on if the user is a member of
# the group.
alpha_testers = Togls.rule(:group, [1, 23, 42, 83], :user_id)

Togls.release do
  feature(:new_contact_form, "use new contact form", :user_id).on(alpha_testers)
end
```

```ruby
if Togls.feature(:new_contact_form).on?(current_user.id)
  # Use new contact form
else
  # Use old contact form
end
```

The key take away is that the
[Togls::Rules::Group](https://github.com/codebreakdown/togls/wiki/Provided-Rules-Reference#toglsrulesgroup)
rule can be used to define any group you like.

## Advanced Usage

`togls` is capable of much, much more. We have strategically avoided
including details of advanced usage in the `README.md` as to not
overwhelm people on first impression. For more details on some of the
more advanced features feel free to check out our
[Wiki](https://github.com/codebreakdown/togls/wiki). Just a few of the
many things it contains are
[Testing with
Toggles](https://github.com/codebreakdown/togls/wiki/Testing-with-Toggles),
[Provided Rules
Reference](https://github.com/codebreakdown/togls/wiki/Provided-Rules-Reference),
[Custom
Rules](https://github.com/codebreakdown/togls/wiki/Custom-Rule-Types-&-Rules),
[Organize Toggle
Definitions](https://github.com/codebreakdown/togls/wiki/Organize-Toggle-Definitions),
[Creating Additional Toggle
Registries](https://github.com/codebreakdown/togls/wiki/Create-Additional-Toggle-Registries),
etc.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/codebreakdown/togls/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
