# Togl

A lightweight feature toggle library.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'togl'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install togl

## Usage

### Setup

The default behaviour for any feature that has not been defined that is accessed is to default to false.

```ruby
Togl.features do
  # Set this feature to always be on
  feature(:pop_up_login_form).on 
  # Set this feature to always be off
  feature(:send_follup_email).off
  # Create a group rule
  rule = Togl::Rules::Group.new(["user@email.com"])
  feature(:new_contact_form).on(rule)
end
```

### Evaluate

```ruby
if Togl.feature(:new_contact_form).on?("user@email.com")
  # Do my awesome feature
end
```

### Custom Rules

A simple rule can be defined by created a rule object and passing a block

```ruby
# Only allow users with email addresses at gmail.com
gmail_rule = Togl::Rule.new { |target| target =~ /gmail.com$/ }

Togl.features do
  feature(:only_gmail_users).on(gmail_rule)
end
```

To implement a more complex rule a new rule object can be defined under Togl::Rules that implements the run method and returns a boolean. When a feature is defined, the rule will be added to the feature object and the run method called with whatever target is passed.

```ruby
module Togl
  module Rules
    class Group < Rule
      def initialize(list)
        @list = list
      end

      def run(target)
        @list.include?(target)
      end
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/togl/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
