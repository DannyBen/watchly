require 'tmpdir'
require 'fileutils'

describe Snapshot do
  subject(:snapshot) { described_class.new globs }

  let(:globs) { File.join(tmpdir, '**', '*') }
  let(:tmpdir) { Dir.mktmpdir }

  after { FileUtils.remove_entry(tmpdir) }

  describe '#files' do
    context 'when files exist' do
      before do
        File.write(File.join(tmpdir, 'a.txt'), 'hello')
        File.write(File.join(tmpdir, 'b.txt'), 'world')
      end

      it 'returns a hash keyed by file path' do
        expect(snapshot.files.keys).to contain_exactly(File.join(tmpdir, 'a.txt'), File.join(tmpdir, 'b.txt'))
      end

      it 'stores file metadata as a two-element array' do
        snapshot.files.each_value do |metadata|
          expect(metadata).to be_an(Array)
          expect(metadata.size).to eq(2)
        end
      end
    end

    context 'when directories are matched by the glob' do
      before { Dir.mkdir(File.join(tmpdir, 'subdir')) }

      it 'ignores directories' do
        expect(snapshot.files).to be_empty
      end
    end
  end

  describe '#diff' do
    let(:file_path) { File.join(tmpdir, 'file.txt') }
    let(:before) { described_class.new globs }

    it 'detects added files' do
      before = described_class.new globs
      File.write(file_path, 'hello')
      after = described_class.new globs

      changes = before.diff after

      expect(changes.added).to eq([file_path])
      expect(changes.removed).to be_empty
      expect(changes.modified).to be_empty
    end

    it 'detects removed files' do
      File.write(file_path, 'hello')
      before = described_class.new globs
      FileUtils.rm file_path
      after = described_class.new globs

      changes = before.diff after

      expect(changes.removed).to eq([file_path])
    end

    it 'detects modified files' do
      File.write file_path, 'hello'
      before = described_class.new globs
      File.write file_path, 'goodbye'
      future = Time.now + 10
      File.utime future, future, file_path
      after = described_class.new globs

      changes = before.diff after

      expect(changes.modified).to eq([file_path])
    end
  end

  describe '#==' do
    subject(:snapshot) { described_class.new 'glob' }

    let(:other) { described_class.new 'glob' }

    context 'when files are equal' do
      it 'returns true' do
        allow(snapshot).to receive(:files).and_return({ 'a.txt' => [1, 100] })
        allow(other).to receive(:files).and_return({ 'a.txt' => [1, 100] })

        expect(snapshot).to eq(other)
      end
    end

    context 'when files differ' do
      it 'returns false' do
        allow(snapshot).to receive(:files).and_return({ 'a.txt' => [1, 100] })
        allow(other).to receive(:files).and_return({ 'a.txt' => [2, 100] })

        expect(snapshot).not_to eq(other)
      end
    end

    context 'when compared with a non-snapshot' do
      it 'returns false' do
        allow(snapshot).to receive(:files).and_return({})

        expect(snapshot == Object.new).to be false
      end
    end
  end
end
