# Watchly

Watchly is a lightweight, dependency-free, polling-based file watcher for Ruby.
It watches one or more glob patterns and reports changes.

## Installation

```bash
gem install watchly
```

Or in your Gemfile:

```ruby
gem 'watchly'
```

## Usage

**Initialize a watcher:**

```ruby
require 'watchly'

# with the default interval (1 second)
watcher = Watchly::Watcher.new '**/*'

# with a different interval
watcher = Watchly::Watcher.new '**/*', interval: 2.0

# with multiple glob patterns
watcher = Watchly::Watcher.new 'spec/**/*.rb', 'lib/*.*'
```

**Watch for changes:**

```ruby
watcher.on_change do |changes|
  puts "Added: #{changes.added.join(', ')}" if changes.added.any?
  puts "Removed: #{changes.removed.join(', ')}" if changes.removed.any?
  puts "Modified: #{changes.modified.join(', ')}" if changes.modified.any?
end
```

**Stop the watcher:**

```ruby
# Mainly for tests, but can be called from another thread
watcher.stop
```

## Contributing / Support

If you experience any issue, have a question, or if you wish
to contribute, feel free to [open an issue][issues].

[issues]: https://github.com/dannyben/watchly/issues
