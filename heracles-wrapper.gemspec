# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'heracles-wrapper/version'

Gem::Specification.new do |gem|
  gem.name          = "heracles-wrapper"
  gem.version       = Heracles::Wrapper::VERSION
  gem.authors       = [
    "Jeremy Friesen"
  ]
  gem.email         = [
    "jeremy.n.friesen@gmail.com"
  ]
  gem.description   = %q{API Wrapper for Heracles workflow manager}
  gem.summary       = %q{API Wrapper for Heracles workflow manager}
  gem.homepage      = "https://github.com/ndlib/heracles-wrapper"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "rest-client"
  gem.add_dependency "morphine"
  gem.add_dependency "json" if RUBY_VERSION =~ /\A1\.8/
  gem.add_dependency "method_decorators"
  gem.add_development_dependency "webmock"
  gem.add_development_dependency "debugger" if RUBY_VERSION !~ /\A1\.8/
  gem.add_development_dependency "minitest"
  gem.add_development_dependency "minitest-matchers"

end
