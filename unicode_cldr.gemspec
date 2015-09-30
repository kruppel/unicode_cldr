require File.expand_path('../lib/unicode/cldr/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'unicode_cldr'
  gem.version     = Unicode::Cldr::VERSION
  gem.authors     = ['Kurt Ruppel']
  gem.email       = 'me@kurtruppel.com'
  gem.summary     = 'CLDR data in YAML'
  gem.description = 'CLDR data in YAML'
  gem.homepage    = 'https://github.com/kruppel/unicode_cldr'
  gem.files       = Dir['lib/**/*', 'README.md']

  gem.add_runtime_dependency 'json'
end
