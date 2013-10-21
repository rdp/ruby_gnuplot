# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gnuplot/version"

lib_rb_files = Dir.glob( File.join( "lib", "**", "*.rb") )
test_rb_files = Dir.glob( File.join( "test", "**", "*.rb") )
examples_rb_files = Dir.glob( File.join( "examples", "**", "*.rb") )

Gem::Specification.new do |s|
  s.name        = 'gnuplot'
  s.description = "Utility library to aid in interacting with gnuplot from ruby"
  s.summary 	= "Utility that could be used to create different types of plot (see gnuplot)."
  s.version     = Gnuplot::VERSION
  s.authors     = 'roger pack'
  s.email       = "rogerpack2005@gmail.com"
  s.homepage    = "http://github.com/rdp/ruby_gnuplot/tree/master"
  s.files		= lib_rb_files + test_rb_files + examples_rb_files + [ "Rakefile" ]
  s.add_development_dependency 'rake'
end
