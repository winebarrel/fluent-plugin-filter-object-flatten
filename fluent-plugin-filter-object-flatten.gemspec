# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fluent_plugin_filter_object_flatten/version'

Gem::Specification.new do |spec|
  spec.name          = 'fluent-plugin-filter-object-flatten'
  spec.version       = FluentPluginFilterObjectFlatten::VERSION
  spec.authors       = ['Genki Sugawara']
  spec.email         = ['sgwr_dts@yahoo.co.jp']

  spec.summary       = %q{Filter Plugin to convert the hash record to records of key-value pairs.}
  spec.description   = %q{Filter Plugin to convert the hash record to records of key-value pairs.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'fluentd', '>= 0.12'
  spec.add_dependency 'object_flatten'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '>= 3.0.0'
end
