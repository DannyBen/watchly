require 'tmpdir'
require 'fileutils'

def run_watcher(watcher)
  Thread.new do
    watcher.on_change do |changes|
      yield changes
      watcher.stop
    end
  end
end

def start_watcher(watcher, &block)
  Thread.new { watcher.on_change(&block) }
end

def touch_file(path, contents = 'hello')
  sleep 0.01
  File.write path, contents
end

def run_without_changes(watcher, wait: 0.05)
  yielded = false
  thread = start_watcher(watcher) do
    # :nocov: this is only reached on failure
    yielded = true
    # :nocov:
  end

  sleep wait
  watcher.stop
  thread.join

  yielded
end

describe Watcher do
  subject do
    described_class.new(
      File.join(tmpdir, '**', '*'),
      interval: 0.01
    )
  end

  let(:tmpdir) { Dir.mktmpdir }
  let(:file_path) { File.join tmpdir, 'file.txt' }

  after { FileUtils.remove_entry tmpdir }

  describe '#on_change' do
    it 'yields when a file is added' do
      yielded = nil
      thread = run_watcher(subject) { |changes| yielded = changes }
      touch_file file_path
      thread.join

      expect(yielded).to be_a(Changeset)
      expect(yielded.added).to eq([file_path])
    end

    it 'does not re-yield unchanged state across iterations' do
      yielded = []
      thread = run_watcher(subject) { |changes| yielded << changes }
      touch_file file_path
      thread.join

      expect(yielded.size).to eq(1)
    end

    context 'when no block is given' do
      it 'raises an ArgumentError' do
        expect { subject.on_change }.to raise_error ArgumentError
      end
    end

    context 'when no changes occur' do
      it 'does not yield' do
        expect(run_without_changes(subject)).to be false
      end
    end
  end
end
