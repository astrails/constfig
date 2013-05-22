# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'constfig/version'

Gem::Specification.new do |gem|
  gem.name          = "constfig"
  gem.version       = Constfig::VERSION
  gem.authors       = ["Vitaly Kushner"]
  gem.email         = ["vitaly@astrails.com"]
  gem.description   = %q{Simple Constnt Configuration for Ruby. Creates CONSTANTS with values from ENV}
  gem.summary       = %q{Simple Constnt configuration for Ruby.}
  gem.homepage      = "http://astrails.com/blog/constfig"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
