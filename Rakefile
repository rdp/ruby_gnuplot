require 'jeweler2'
Jeweler::Tasks.new do |s|
  s.name = 'gnuplot'
  s.description = s.summary = "Utility library to aid in interacting with gnuplot from ruby"
  s.version = "2.6.1"
  s.authors='roger pack'
  s.email = "rogerpack2005@gmail.com"
  s.homepage = "http://github.com/rdp/ruby_gnuplot/tree/master"
end

desc 'run unit tests'
task :test do
  Dir.chdir 'test'
  for file in Dir['*']
    system("ruby #{file}")
  end
end

Jeweler::RubygemsDotOrgTasks.new