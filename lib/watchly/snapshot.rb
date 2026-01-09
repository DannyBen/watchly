module Watchly
  class Snapshot
    attr_reader :globs, :files

    def initialize(globs)
      @globs = globs
      @files = capture(globs)
    end

    def diff(other)
      Changeset.new(
        added:    added_files(other),
        removed:  removed_files(other),
        modified: modified_files(other)
      )
    end

    def ==(other)
      return false unless other.is_a? self.class

      files == other.files
    end

  private

    def added_files(other) = other.files.keys - files.keys
    def removed_files(other) = files.keys - other.files.keys

    def modified_files(other)
      (files.keys & other.files.keys).reject do |path|
        files[path] == other.files[path]
      end
    end

    def capture(globs)
      Array(globs)
        .flat_map { |glob| Dir.glob glob }
        .uniq
        .each_with_object({}) do |path, acc|
          next unless File.file? path

          stat = File.stat path
          acc[path] = [stat.mtime.to_i, stat.size]
        end
    end
  end
end
