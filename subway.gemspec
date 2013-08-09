# -*- encoding: utf-8 -*-

require File.expand_path('../lib/subway/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = "subway"
  gem.version     = Subway::VERSION.dup
  gem.authors     = [ "Martin Gamsjaeger (snusnu)" ]
  gem.email       = [ "gamsnjaga@gmail.com" ]
  gem.description = "substation on rack"
  gem.summary     = "Implement web applications using rack, a router and substation"
  gem.homepage    = "https://github.com/snusnu/subway"

  gem.require_paths    = [ "lib" ]
  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- {spec}/*`.split("\n")
  gem.extra_rdoc_files = %w[LICENSE README.md TODO.md]

  gem.add_dependency 'rack',       '~> 1.5.2'
  gem.add_dependency 'substation', '~> 0.0.9'

  gem.add_development_dependency 'bundler', '~> 1.3.5'
end
