require 'bundler'
Bundler.setup

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "syncsign/version"
require "yard"

YARD::Rake::YardocTask.new do |t|
  t.files = ['lib/**/*.rb']
  t.options = %w(--markup-provider=redcarpet --markup=markdown --main=README.md)
end

desc "Builds the gem"
task :gem => :build
task :build => :yard do
  system "gem build syncsign.gemspec"
  Dir.mkdir("pkg") unless Dir.exists?("pkg")
  system "mv syncsign-#{SyncSign::VERSION}.gem pkg/"
end

task :install => :build do
  system "sudo gem install pkg/syncsign-#{SyncSign::VERSION}.gem"
end

desc "Release the gem - Gemcutter"
task :release => :build do
  system "git tag -a v#{SyncSign::VERSION} -m 'Tagging #{SyncSign::VERSION}'"
  system "git push --tags"
  system "gem push pkg/syncsign-#{SyncSign::VERSION}.gem"
end

task :default => [:spec]
