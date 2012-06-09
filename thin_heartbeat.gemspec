# -*- encoding: utf-8 -*-
require File.expand_path('../lib/thin_heartbeat/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Edward Weng"]
  gem.email         = ["edweng@gmail.com"]
  gem.description   = %q{Gem that will handle Faye heartbeats}
  gem.summary       = %q{Gem that will handle Faye heartbeats}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "thin_heartbeat"
  gem.require_paths = ["lib"]
  gem.version       = ThinHeartbeat::VERSION

  gem.add_runtime_dependency 'redis'
  gem.add_runtime_dependency 'json'
  gem.add_runtime_dependency 'hashie'
  gem.add_development_dependency 'rspec'
end
