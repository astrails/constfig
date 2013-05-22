# Constfig

Simple configuration for Ruby.

Allows you to define configuration CONSTANTS that take values from ENV.

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

### Variable type

One last thing. Non-string variables are supported. If you provide a non-string
default (boolean, integer, float or symbol), the value that is coming from
`ENV` will be converted to the same type (using `to_i`, `to_f`, and
`to_symbol`).  For the true/false types `"true"`, `"TRUE"`, and `"1"` will be
treated as `true`, anything else will be treated as `false`.

In the case of required variables, you can supply a `Class` in place of the
default, and it will be used for the type conversion. Like this:

    define_config :EXPIRATION_DAYS, Fixnum

For boolean variables you can supply either `TrueClass`, or  `FalseClass`.

### Existing constants

This gem will not re-define existing constants, which can be used to define
DEFAULTS for development environment.

For example in Rails you con do this:

    unless ['production', 'staging'].include?(Rails.env)
      DEFAULT_DOMAIN = 'myapp.dev'
    end

    define_config :DEFAULT_DOMAIN

In development and test environments it willuse 'myapp.dev' ad
`PRIMARY_DOMAIN`, but in production and staging environment it will fail unless
`PRIMARY_DOMAIN` is provided by environment

### Managing environment

You can use the [dotenv gem](https://github.com/bkeepers/dotenv) to manage your `ENV`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
