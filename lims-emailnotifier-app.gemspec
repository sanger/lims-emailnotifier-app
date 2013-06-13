# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "lims-emailnotifier-app/version"

Gem::Specification.new do |s|
  s.name        = "lims-emailnotifier-app"
  s.version     = Lims::EmailNotifierApp::VERSION
  s.authors     = ["Karoly Erdos"]
  s.email       = ["ke4@sanger.ac.uk"]
  s.homepage    = "http://sanger.ac.uk/"
  s.summary     = %q{This application listens to the message queue and sends an e-mail if a massege has arrived to the queue}
  s.description = %q{Provides utility functions for the new LIMS}

  s.rubyforge_project = "lims-emailnotifier-app"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib", "config"]

  s.add_dependency('bunny', '0.9.0.pre10')
  s.add_dependency('rest-client')

  s.add_development_dependency('rake', '~> 0.9.2')
  s.add_development_dependency('rspec', '~> 2.8.0')
  s.add_development_dependency('hashdiff')
  s.add_development_dependency('rack-test', '~> 0.6.1')
  s.add_development_dependency('yard', '>= 0.7.0')
  s.add_development_dependency('yard-rspec', '0.1')
  s.add_development_dependency('github-markup', '~> 0.7.1')
end
