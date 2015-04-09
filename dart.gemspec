# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dart/version'

Gem::Specification.new do |spec|
  spec.name          = "dart"
  spec.version       = Dart::VERSION
  spec.authors       = ["Ed Posnak"]
  spec.email         = ["ed.posnak@gmail.com"]
  spec.summary       = %q{database association resolver toolkit}
  spec.description   = %q{database association resolver toolkit for postgres, activemodel, sequel, etc.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'abstract_method'

  spec.add_development_dependency 'pg'
  spec.add_development_dependency 'sequel'
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest'
end
