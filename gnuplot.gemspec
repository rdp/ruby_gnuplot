# -*- ruby -*-

spec = Gem::Specification.new do |s|
  s.name = 'gnuplot'
  s.description = s.summary = "Utility library to aid in interacting with gnuplot"
  s.version = "2.2.3.0"
  s.platform = Gem::Platform::RUBY
  s.date  = Time.new

  s.files = [ "lib/gnuplot.rb" ]

  s.autorequire = 'gnuplot.rb'
  s.author = "Gordon James Miller, Roger Pack"
  s.email = "rogerpack2005@gmail.com"
  s.homepage = "http://github.com/rogerdpack/ruby_gnuplot/tree/master"
end

if $0==__FILE__
  Gem::Builder.new(spec).build
end

spec
