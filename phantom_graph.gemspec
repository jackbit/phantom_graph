# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
# Maintain your gem's version:
require "phantom_graph/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "phantom_graph"
  s.version     = PhantomGraph::VERSION
  s.authors     = ["Yacobus Reinhart"]
  s.email       = ["yacobus.reinhart@gmail.com"]
  s.homepage    = "https://github.com/jackbit"
  s.summary     = "Generate highchart to graph with phantomjs on serverside"
  s.description = "Generate highchart to graph with phantomjs on serverside"
  s.files       = `git ls-files`.split($/)
  s.files.reject! { |fn| fn.include? "script" }
  s.executables   = s.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = %w(lib)
  s.requirements << 'phantomjs, v1.6 or greater'
  s.add_runtime_dependency "json"

  # Developmnet Dependencies
  s.add_development_dependency(%q<rake>, [">=0.9.2"])
  s.add_development_dependency(%q<rspec>, [">= 2.2.0"])
  s.add_development_dependency(%q<rack-test>, [">= 0.5.6"])

end
