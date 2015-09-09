[![Gem Version](https://badge.fury.io/rb/togls.svg)](http://badge.fury.io/rb/togls)
[![Build Status](https://travis-ci.org/codebreakdown/togls.svg?branch=master)](https://travis-ci.org/codebreakdown/togls)
[![Code Climate](https://codeclimate.com/github/codebreakdown/togls/badges/gpa.svg)](https://codeclimate.com/github/codebreakdown/togls)
[![Test Coverage](https://codeclimate.com/github/codebreakdown/togls/badges/coverage.svg)](https://codeclimate.com/github/codebreakdown/togls/coverage)
[![Dependency Status](https://gemnasium.com/codebreakdown/togls.svg)](https://gemnasium.com/codebreakdown/togls)

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
Togls.features do
  # Set this feature to always be on
  feature(:pop_up_login_form, "use pop up login instead of normal login").on 

  # Set this feature to always be off
  feature(:send_follup_email, "send the follow up email").off
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

**Note:** The default behaviour for any feature that has not been
defined and is accessed is to default to **off**.

### Toggle Features based on Group Membership  

`togls` provides out of the box support for toggling features based on
group membership. This basically allows you to have a feature **on** for
members of a defined group and **off** for non-members. This can be
extremely useful if you want to enable features for a small alpha test
group for example.

**Note:** This is implemented using `togls` extremely robust [custom
rule]() system that we go into below. The following example is just one
of the many powerful things you can do with `togls`.

#### Defining Group based Feature Toggles

The following is an example definition of a feature that toggles on
based on group membership.

```ruby
# Create a group rule so the feature is on if the user is a member of
# the group.
alpha_testers = Togls::Rules::Group.new(["user1@email.com",
                                         "user2@example.com"])

Togls.features do
  feature(:new_contact_form, "use new contact form").on(alpha_testers)
end
```

The above is really broken down into two steps.

1. Construct the [rule]() you want to use
2. Define the feature toggle and pass the [rule]() to its `on()` method

In the above example we construct an instance of the
[Togls::Rules::Group]() rule, passing it the list of alpha tester email
addresses. [Togls::Rules::Group]() is a rule that `togls` provides to
make your life a bit simpler.

Then we define a feature, `:new_contact_form`, that will be on for
alpha testers and off for people that don't fall within that group.

#### Evaluating Group based Feature Toggles

Group based rules are evaluated by using the `on?` method. However, in
this case we have to pass the `on?` method the `target`. The `target` in
this case is the email address of the current user. The target is the
identifier that you want to check if it belongs to the group or not.

```ruby
if Togls.feature(:new_contact_form).on?("user@email.com")
  # Use new contact form
else
  # Use old contact form
end
```

#### Groups of Anything

You could just as easily used user ids instead of email addresses in the
example above and it would look something like the following:

```ruby
# Create a group rule so the feature is on if the user is a member of
# the group.
alpha_testers = Togls::Rules::Group.new([1, 23, 42, 83])

Togls.features do
  feature(:new_contact_form, "use new contact form").on(alpha_testers)
end
```

```ruby
if Togls.feature(:new_contact_form).on?(222)
  # Use new contact form
else
  # Use old contact form
end
```

The key take away is that the `Togls::Rules::Group` rule can be used to
define any group you like.

### Custom Rules

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/codebreakdown/togls/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
