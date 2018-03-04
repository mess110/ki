# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rdoc/task'

RDoc::Task.new do |rdoc|
  rdoc.main = 'README.md'
  rdoc.rdoc_files
      .include('README.md', 'lib/**/*.rb')
  rdoc.rdoc_dir = 'doc'
end

RSpec::Core::RakeTask.new(:spec)

task default: :spec
