# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'maildis/version'

Gem::Specification.new do |gem|
  gem.name          = "maildis"
  gem.version       = Maildis::VERSION
  gem.authors       = ["Johnny Boursiquot"]
  gem.email         = ["jboursiquot@gmail.com"]
  gem.description   = %q{Maildis is a command line bulk email dispatching tool. It uses ERB templates and comma-separated values (CSV) files as a merge mechanism.}
  gem.summary       = %q{Maildis is a command line bulk email dispatching tool. It uses ERB templates and comma-separated values (CSV) files as a merge mechanism. It relies on SMTP information you provide through your own configuration file. Subject, sender, path to CSV, path to ERB templates (HTML and plain) are all configurable through YAML.}
  gem.homepage      = "https://github.com/jboursiquot/maildis"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'thor'
  gem.add_runtime_dependency 'pony'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'rb-fsevent','~> 0.9.1'
  gem.add_development_dependency 'fivemat'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'pry-debugger'
  gem.add_development_dependency 'mailcatcher'

end
