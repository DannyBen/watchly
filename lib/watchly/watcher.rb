module Watchly
  class Watcher
    DEFAULT_INTERVAL = 1.0

    attr_reader :globs, :interval, :stopped

    def initialize(*globs, interval: nil)
      @globs = globs
      @interval = interval || DEFAULT_INTERVAL
      @stopped = false
    end

    def stop = @stopped = true

    def on_change
      raise ArgumentError, 'Block required' unless block_given?

      previous = Snapshot.new globs

      until stopped
        sleep interval

        current = Snapshot.new globs
        next if previous == current

        changes = previous.diff current
        yield changes

        previous = current
      end
    end
  end
end
