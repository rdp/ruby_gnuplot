# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gnuplot/version"

Gem::Specification.new do |s|
  s.name        = 'gnuplot'
  s.description = s.summary = "Utility library to aid in interacting with gnuplot from ruby"
  s.version     = Gnuplot::VERSION
  s.authors     = 'roger pack'
  s.email       = "rogerpack2005@gmail.com"
  s.homepage    = "http://github.com/rdp/ruby_gnuplot/tree/master"

  s.add_development_dependency 'rake'
end
