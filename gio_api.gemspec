# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gio_api/version'

Gem::Specification.new do |s|
  s.name          = "gio_api"
  s.version       = GioApi::VERSION
  s.authors       = ["Mitsuki Kenichi"]
  s.email         = ["happy.siro@gmail.com"]
  s.description   = %q{This Gem is a thing of the run for the gio api}
  s.summary       = %q{This Gem is a thing of the run for the gio api}
  s.homepage      = ""

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "thor", "~> 0.18.1"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

end
