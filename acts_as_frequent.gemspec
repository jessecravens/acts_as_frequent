# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "acts_as_frequent/version"

Gem::Specification.new do |s|
  s.name        = "acts_as_frequent"
  s.version     = ActsAsFrequent::VERSION
  s.authors     = ["Shirjeel Alam"]
  s.email       = ["shirjeel20@gmail.com"]
  s.homepage    = "https://github.com/shirjeel-alam"
  s.summary     = %q{Recurring functionality for Mongoid documents}

  s.rubyforge_project = "acts_as_frequent"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_dependency "bson_ext"
  s.add_dependency "mongoid"
end
