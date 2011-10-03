# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "heatmap/version"

Gem::Specification.new do |s|
  s.name        = "defect-density-heatmap"
  s.version     = Heatmap::VERSION
  s.authors     = ["Brandon Carlson"]
  s.email       = ["bcarlso@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Generates a 'heatmap' from files changed in the SCM system.}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "defect-density-heatmap"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "guard"
  # s.add_runtime_dependency "rest-client"
end
