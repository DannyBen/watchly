lib = File.expand_path 'lib', __dir__
$LOAD_PATH.unshift lib unless $LOAD_PATH.include? lib
require 'watchly/version'

Gem::Specification.new do |s|
  s.name        = 'watchly'
  s.version     = Watchly::VERSION
  s.summary     = 'Lightweight, polling-based file system watcher'
  s.description = [
    'A small, dependency-free, polling-based library that watches',
    'one or more glob patterns and reports on change',
  ].join(' ')
  s.authors     = ['Danny Ben Shitrit']
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*']
  s.homepage    = 'https://github.com/dannyben/watchly'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 3.2'

  s.metadata = {
    'bug_tracker_uri'       => 'https://github.com/dannyben/watchly/issues',
    'changelog_uri'         => 'https://github.com/dannyben/watchly/blob/master/CHANGELOG.md',
    'source_code_uri'       => 'https://github.com/dannyben/watchly',
    'rubygems_mfa_required' => 'true',
  }
end
