# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'forker/version'

Gem::Specification.new do |spec|
  spec.name          = Forker::PRODUCT
  spec.version       = Forker::VERSION
  spec.authors       = ['dkhamsing']
  spec.email         = ['dkhamsing8@gmail.com']

  spec.summary       = Forker::SUMMARY
  spec.description   = spec.summary
  spec.homepage      = Forker::PROJECT_URL
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = [spec.name]
  spec.require_paths = ['lib']

  # dependencies
  spec.add_dependency 'colored', '~> 1.2'   # color output
  spec.add_dependency 'faraday', '~> 0.9.2' # grab url content
  spec.add_dependency 'octokit', '~> 4.1.1' # github
  spec.add_dependency 'netrc', '~> 0.11.0'  # credentials

  spec.add_development_dependency 'bundler', '~> 1.7' # travis needs this at 1.7
  spec.add_development_dependency 'rake', '~> 10.4.2'
  spec.add_development_dependency 'guard-rubocop', '~> 1.2.0'
end
