require "bundler/gem_tasks"
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rubygems/package_task'

require_relative 'lib/ruby_gnuplot/version'

desc 'run unit tests'
task :default => :test

Rake::TestTask.new do |t|
  t.libs << "lib" << 'spec/support'
  t.test_files = FileList['test/**/*.rb']
  t.verbose = false
  t.warning = false
end

def gemspec
  @clean_gemspec ||= eval(File.read(File.expand_path('../ruby_gnuplot.gemspec', __FILE__)))
end

Gem::PackageTask.new(gemspec) { |pkg| }
