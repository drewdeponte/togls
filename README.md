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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/codebreakdown/togls/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
