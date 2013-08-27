# Constfig

Simple configuration for Ruby.

Allows you to define configuration CONSTANTS that take values from environment
variables. With support for default values, required variables and type
conversions.

[![Build Status](https://travis-ci.org/astrails/constfig.png)](https://travis-ci.org/astrails/constfig)
[![Code Climate](https://codeclimate.com/github/astrails/constfig.png)](https://codeclimate.com/github/astrails/constfig)

## Introduction

The are multiple ways of configuring your Rails application for different
environments (e.g. staging, production, etc.). One of the popular ones is
through environment variables. For example Heroku uses this type of
configuration extensively.

One of the benefits of it is that configuration values are never stored in the
source control system, which improves security (for sensitive configuration
parameters) and also makes it easier to try different configuration setups w/o
changing the sources or re-deploying the application.

On the other hand writing `(ENV['PRIMARY_DOMAIN'] || "myapp.com")` every time
you need your domain string becomes cumbersome pretty fast, not to mention
duplication and having the default repeated all over the place.

A competent programmer will of course only do this once, and re-use the value
everywhere. Something like this:

    PRIMARY_DOMAIN = ENV['PRIMARY_DOMAIN'].presence || 'myapp.com'
    S3_BUCKET = ENV['S3_BUCKET'] || raise 'missing S3_BUCKET'
    ORDER_EXPIRATION_DAYS = (ENV['ORDER_EXPIRATION_DAYS'].presence || 1).to_i

But it quickly becomes complicated, and again, quite a bit of similarly looking
code that begs to be refactored out.

This gem is something I extracted from a couple of my latest projects. It
allows you to do just that, have a configuration parameters stored in constants
with values coming from environment variables and ability to provide defaults
or have required parameters (i.e. fail if missing).

## Installation

Add this line to your application's Gemfile:

    gem 'constfig'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install constfig

## Usage

There is only one function provided by the gem: `define_config`.

### With a default (optional variable)

You can call it with a default, like this:

    define_config :DEFAULT_DOMAIN, "astrails.com"

In which case it will first look if `ENV['DEFAULT_DOMAIN']` is available, and
if not will use the 'astrails.com'. A constant `DEFAULT_DOMAIN` will be
defined.

### Without a default (required variable)

Or you can call it without the default:

    define_config :DEFAULT_DOMAIN

In which case it will raise exception `Constfig::Undefined` if
`ENV['DEFAULT_DOMAIN']` is not available.

### Type conversions

Non-string variables are supported. If you provide a non-string default
(boolean, integer, float or symbol), the value that is coming from `ENV` will
be converted to the same type (using `to_i`, `to_f`, and `to_symbol`).  For the
true/false types `"true"`, `"TRUE"`, and `"1"` will be treated as `true`,
anything else will be treated as `false`.

In the case of required variables, you can supply a `Class` in place of the
default, and it will be used for the type conversion. Like this:

    define_config :EXPIRATION_DAYS, Fixnum

For boolean variables you can supply either `TrueClass`, or  `FalseClass`.

There is a special case for `Array`, e.i. when either default value is an array,
or `Array` is passed as type. In this case the value is just passed to `eval`.

### Existing constants

This gem will not re-define existing constants, which can be used to define
defaults for non-production environments.

### Rails on Heroku

There is one caveat with Rails on Heroku. By default Heroku doesn't provide
environment variables to your application during the `rake assets:precompile`
stage of slug compilation. If you don't take care of it your application will
fail to compile its assets and might fail to work in production. To take care
of it you can either use Heroku Labs
[user-env-compile](https://devcenter.heroku.com/articles/labs-user-env-compile)
option, or (and this is what I'd recommend) you can use development defaults
during assets:precompile.

For example in Rails you con do this:

    if Rails.env.development? || Rails.env.test? || ARGV.join =~ /assets:precompile/
      DEFAULT_DOMAIN = 'myapp.dev'
    end

    define_config :DEFAULT_DOMAIN

In development and test environments it will use 'myapp.dev' ad
`PRIMARY_DOMAIN`, but in production and staging environment it will fail unless
`PRIMARY_DOMAIN` is provided by environment.

> NOTE: make sure those configuration variables are not actually used for asset
> compilation. If they are, I'd go with `user-env-compile`.

### Managing environment

You can use the [dotenv gem](https://github.com/bkeepers/dotenv) to manage your `ENV`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
