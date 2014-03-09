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
  gem.license          = 'MIT'

  gem.add_dependency 'rack',        '~> 1.5.2'
  gem.add_dependency 'substation',  '~> 0.0.10'
  gem.add_dependency 'request',     '~> 0.0.4'
  gem.add_dependency 'response',    '~> 0.0.3'
  gem.add_dependency 'anima',       '~> 0.2.0'
  gem.add_dependency 'mustache',    '~> 0.99.4'
  gem.add_dependency 'multi_json',  '~> 1.8.4'
  gem.add_dependency 'rbnacl',      '~> 2.0.0'
  gem.add_dependency 'bcrypt-ruby', '~> 3.1.2'
  gem.add_dependency 'inflecto',    '~> 0.0.2'
  gem.add_dependency 'lupo',        '~> 0.0.1'
  gem.add_dependency 'procto',      '~> 0.0.2'
  gem.add_dependency 'morpher',     '~> 0.2.0'

  gem.add_development_dependency 'bundler', '~> 1.5', '>= 1.5.2'
end
