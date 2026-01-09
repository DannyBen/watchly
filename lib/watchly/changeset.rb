module Watchly
  class Changeset
    attr_reader :added, :removed, :modified

    def initialize(added:, removed:, modified:)
      @added    = added.freeze
      @removed  = removed.freeze
      @modified = modified.freeze
      freeze
    end

    def empty? = added.empty? && removed.empty? && modified.empty?
    def any? = !empty?
    def to_h = { added: added, removed: removed, modified: modified }

    def each
      return enum_for(:each) unless block_given?

      added.each    { |path| yield :added, path }
      removed.each  { |path| yield :removed, path }
      modified.each { |path| yield :modified, path }
    end
  end
end
