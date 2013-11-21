require 'bundler'
Bundler::GemHelper.install_tasks

desc 'run unit tests'
task :test do
  Dir.chdir 'test'
  for file in Dir['*']
    system("ruby #{file}")
  end
end

task :default => :test
