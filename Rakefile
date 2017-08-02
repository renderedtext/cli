require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :quality => [:spec] do
  system("bundle exec rubocop") != false
end

task :default => :quality
