require 'simplecov'

unless ENV['NOCOV']
  SimpleCov.start do
    enable_coverage :branch if ENV['BRANCH_COV']
    coverage_dir 'spec/coverage'
  end
end

require 'rubygems'
require 'bundler'
Bundler.require :default, :development

require 'watchly'
include Watchly

# Consistent Colsole output (for rspec_approvals)
ENV['TTY'] = 'off'
ENV['COLUMNS'] = '80'
ENV['LINES'] = '30'

RSpec.configure do |config|
  config.example_status_persistence_file_path = 'spec/status.txt'
  config.filter_run_excluding :noci if ENV['CI']
end
