# -*- encoding: utf-8 -*-
require File.expand_path('../lib/strikeiron/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Drew Tempelmeyer"]
  gem.email         = ["drewtemp@gmail.com"]
  gem.description   = %q{Ruby gem to handle tax calculation using the Strikeiron API.}
  gem.summary       = %q{Ruby gem to handle tax calculation using the Strikeiron API.}
  gem.homepage      = "https://github.com/drewtempelmeyer/strikeiron"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "strikeiron"
  gem.require_paths = ["lib"]
  gem.version       = Strikeiron::VERSION

  gem.add_dependency 'savon', '~> 0.9.6'

  gem.add_development_dependency 'rake', '~> 0.9.2'
  gem.add_development_dependency 'rdoc', '~> 3.12'
  gem.add_development_dependency 'vcr', '~> 2.1.1'
  gem.add_development_dependency 'webmock', '~> 1.8.6'

end
