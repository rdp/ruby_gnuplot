# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_gnuplot/version'

Gem::Specification.new do |s|
  s.name = 'gnuplot'
  s.description = s.summary = "Utility library to aid in interacting with gnuplot from ruby"
  s.version = RubyGnuplot::VERSION
  s.authors='roger pack'
  s.email = "rogerpack2005@gmail.com"
  s.homepage = "http://github.com/rdp/ruby_gnuplot/tree/master"
  s.license = "BSD"

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rspec',     '3.9.0'
  s.add_development_dependency 'simplecov', '0.17.0'
end
