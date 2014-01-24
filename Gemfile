# encoding: utf-8

source 'https://rubygems.org'

SNUSNU = 'https://github.com/snusnu'.freeze
MBJ    = 'https://github.com/mbj'.freeze
ROM_RB = 'https://github.com/rom-rb'.freeze

MASTER = 'master'.freeze

gemspec

gem 'anima',      git: "#{MBJ}/anima.git",         branch: MASTER
gem 'morpher',    git: "#{MBJ}/morpher.git",       branch: MASTER

gem 'substation', git: "#{SNUSNU}/substation.git", branch: MASTER
gem 'request',    git: "#{SNUSNU}/request.git",    branch: 'cookie'
gem 'response',   git: "#{SNUSNU}/response.git",   branch: 'cookie'
gem 'cookie',     git: "#{SNUSNU}/cookie.git",     branch: MASTER
gem 'lupo',       git: "#{SNUSNU}/lupo.git",       branch: MASTER
gem 'procto',     git: "#{SNUSNU}/procto.git",     branch: MASTER

group :development do
  gem 'devtools', git: "#{ROM_RB}/devtools.git",    branch: MASTER
end

# added by devtools
eval_gemfile 'Gemfile.devtools'
