[![Version](https://img.shields.io/gem/v/togls.svg)](https://rubygems.org/gems/togls)
[![Build Status](https://travis-ci.org/codebreakdown/togls.svg?branch=master)](https://travis-ci.org/codebreakdown/togls)
[![Code Climate](https://img.shields.io/codeclimate/github/codebreakdown/togls.svg)](https://codeclimate.com/github/codebreakdown/togls)
[![Code
Coverage](https://img.shields.io/codeclimate/coverage/github/codebreakdown/togls.svg)](https://codeclimate.com/github/codebreakdown/togls)
[![Dependency Status](https://gemnasium.com/codebreakdown/togls.svg)](https://gemnasium.com/codebreakdown/togls)

# Togls

A lightweight feature toggle library for Ruby.

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

The basic usage of `Togls` is outlined below.

### Defining Feature Toggles

The first thing to do to use `Togls` is to define your feature toggles.
The following is an example of how you might define your feature
toggles. It is recommended this live in its own file. In Rails projects
we recommend putting it in `config/initializers/togls_features.rb`.

```ruby
Togls.features do
  # Set this feature to always be on
  feature(:pop_up_login_form, "use the pop up login instead of normal login").on 

  # Set this feature to always be off
  feature(:send_follup_email, "send the follow up email").off

  # Create a group rule so the feature is on if the user is a member of
  # the group.
  rule = Togls::Rules::Group.new(["user@email.com"])
  feature(:new_contact_form, "use new contact form instead of old one").on(rule)
end
```

### Evaluating Feature Toggles

Once you have defined your feature toggles. The next thing you would
likely want to do is conditionally control something based on them. The
following are a few examples of how you would do this given the above.

```ruby
if Togls.feature(:pop_up_login_form).on?
  # Use pop up login form
else
  # Use normal non-pop up login form
end

if Togls.feature(:send_follup_email).on?
  # send the follow up email
end

if Togls.feature(:new_contact_form).on?("user@email.com")
  # Use new contact form
else
  # Use old contact form
end
```

**Note:** The default behaviour for any feature that has not been
defined and is accessed is to default to **off**.

## Advanced Usage

Below is a breakdown of some of the more advanced features of `Togls`
which aren't necessary in order to use it for basic feature toggles.

### Override Default Boolean Rule

`Togls` allows you to override the Rule class that is used for default
boolean values. This rule class is used when you use the convenience
methods `on` and `off`. The default boolean rule class is
`Togls::Rules::Boolean`.

If you want to use a different default boolean rule, lets say,
`Togls::Rules::BooleanEnvOverride`  you can override the default by
doing the following:

```ruby
Togls.features(Togls::Rules::BooleanEnvOverride) do
  feature(:some_feature, "some feature description").on
  feature(:some_other_feature, "some other feature description").on
end
```

### Custom Rules

`Togls` is specifically architected on top of a generic concept of a
`Togls::Rule`.  This empowers the users to define any custom rules they
would like and use them to control their feature toggles.  For example,
you could use them to do A/B testing, define alpha test group, give a
percentage of a user base a feature, etc.

### Simple Rules

A simple rule can be defined by creating a rule object and passing a
block. In the following example any feature using the `gmail_rule` would
only be on if the given `target` contained `gmail.com` at the end of the
`target`. *Note:* The block is also handed the feature's key which can
be used to evaluate the boolean result as well.

```ruby
# Only allow users with email addresses at gmail.com
gmail_rule = Togls::Rule.new { |key, target| target =~ /gmail.com$/ }

Togls.features do
  feature(:only_gmail_users, "Only enabled for Gmail users").on(gmail_rule)
end
```

### Complex Rules

To implement a more complex rule, a new rule object can be defined that
abides by the following.

- inherits from `Togls::Rule` or a decendent of it
- has an instance method named `run` that takes a required feature key
  and either a default value parameter of `target` or a required
  paramter of `target`.

    ```ruby
    def run(key, target = 'foo')
    ...
    end
    
    # or

    def run(key, target)
    ...
    end
    ```

- has the instance method named `run` return a boolean value identifying
  if that feature should be on(**true**)/off(**false**) given the `key`
  and `target`.

Thats it!

#### Example Complex Rule

Internally `Togls` uses these *Complex Rules* to provide functionality
and will evolve to contain more official rules over time. If you have a
generic *Complex Rule* you think should be part of `Togls` please make a
pull request.

A prime example of a *Complex Rule* provided by `Togls` is the
`Togls::Rules::Group` rule. You can see it below.

```ruby
module Togls
  module Rules
    class Group < Rule
      def initialize(list)
        @list = list
      end

      def run(key, target)
        @list.include?(target)
      end
    end
  end
end
```

Lets take a closer look at exactly what is going on here.

- it is inheriting from the `Togls::Rule` class which meets one of the
  minimum requirements for a rule.
- it defined constructor takes an array of identifiers and stores them.
  These identifiers could be id numbers, email address, etc. **Note:**
  This constructor is completely different than that of `Togls::Rule`.
  This is fine because it is **not** a requirement that the constructor
  match.
- its `run` method returns a boolean value identifying if the feature
  should be on(**true**)/off(**false**) for the given `key` and
  `target`. It does so by identifying if the array passed in at
  construction time `include?` the given `target`.  This meets one of
  the minimum requirement for a rule.
- its `run` method signature requires a `key` and `target`. This meets a
  minimum requirement for a rule as well. It also makes sense in the
  case of group based rule as it has to have something to compare
  against the group.

*Complex Rules* are a simple yet extremely power concept that you
shouldn't hesitate to use.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/codebreakdown/togls/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
