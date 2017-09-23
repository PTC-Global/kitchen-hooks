# frozen_string_literal: true

require 'ci/reporter/rake/minitest'
require 'shellwords'
require 'bundler'
require 'rake'

# "rake test"
require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.test_files = FileList['test/test*.rb']
  test.verbose = true
end

task default: :test

task minitest: %w[ci:setup:minitest test]

task :report do
  %w[minitest yard].each do |task_name|
    sh "bundle exec rake #{task_name}" do
      # Ignore errors
    end
  end
end

# "rake yard"
require 'yard'
YARD::Rake::YardocTask.new do |t|
  t.files = %w[--readme Readme.md lib/**/*.rb - VERSION]
end

# "rake build"
require 'rubygems/tasks'
Gem::Tasks.new(sign: {}) do |tasks|
  tasks.console.command = 'pry'
end
Gem::Tasks::Sign::Checksum.new sha2: true

# "rake version"
require 'rake/version_task'
Rake::VersionTask.new
