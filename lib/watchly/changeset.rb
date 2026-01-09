module Watchly
  class Changeset
    attr_reader :added, :removed, :modified, :files

    def initialize(added:, removed:, modified:)
      @added    = added.freeze
      @removed  = removed.freeze
      @modified = modified.freeze
      @files    = (added + modified).freeze
      freeze
    end

    def empty? = files.empty?
    def any? = !empty?
    def to_h = { added: added, removed: removed, modified: modified, files: files }

    def each
      return enum_for(:each) unless block_given?

      added.each    { |path| yield :added, path }
      removed.each  { |path| yield :removed, path }
      modified.each { |path| yield :modified, path }
    end
  end
end
