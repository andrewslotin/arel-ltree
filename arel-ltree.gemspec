# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arel-ltree'

Gem::Specification.new do |spec|
  spec.name          = "arel-ltree"
  spec.version       = Arel::Ltree::VERSION
  spec.authors       = ["Andrew Slotin"]
  spec.email         = ["andrew.slotin@gmail.com"]
  spec.description   = %q{Arel extension for PostgreSQL ltree type}
  spec.summary       = %q{Adds support for ltree operatos to Arel}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "arel"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
