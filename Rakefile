require "bundler/gem_tasks"
require 'rspec/core'
require 'rspec/core/rake_task'

task :default => [:spec]

desc 'Runs all specs'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
  spec.rspec_opts = ["--format Fivemat", "--color"]
end
