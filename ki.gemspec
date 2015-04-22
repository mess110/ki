# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ki/version'

Gem::Specification.new do |spec|
  spec.name          = 'ki'
  spec.version       = Ki::VERSION
  spec.authors       = ['Cristian Mircea Messel']
  spec.email         = ['mess110@gmail.com']
  spec.summary       = 'it said optional'
  spec.description   = 'it said optional'
  spec.homepage      = 'https://github.com/mess110/ki'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib examples)

  spec.add_runtime_dependency 'bundler', '~> 1.5'
  spec.add_runtime_dependency 'rack'
  spec.add_runtime_dependency 'rack-parser'
  spec.add_runtime_dependency 'thor'
  spec.add_runtime_dependency 'haml'
  spec.add_runtime_dependency 'sass'
  spec.add_runtime_dependency 'coffee-script'
  spec.add_runtime_dependency 'mongo', '1.9.2'
  spec.add_runtime_dependency 'bson_ext'
  spec.add_runtime_dependency 'rack-cors'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-rubocop'
  spec.add_development_dependency 'codeclimate-test-reporter'
end
