describe Changeset do
  subject(:empty_subject) do
    described_class.new(added: [], removed: [], modified: [])
  end

  let(:added)    { ['one more.txt'] }
  let(:removed)  { ['one less.txt'] }
  let(:modified) { ['one different.txt'] }

  let(:changed_subject) do
    described_class.new(added:, removed:, modified:)
  end

  let(:removed_only_subject) do
    described_class.new(added: [], removed:, modified: [])
  end

  let(:events) do
    [
      [:added,    added.first],
      [:removed,  removed.first],
      [:modified, modified.first],
    ]
  end

  describe '#files' do
    it 'includes added and modified files' do
      expect(changed_subject.files)
        .to match_array(added + modified)
    end

    it 'excludes removed files' do
      expect(changed_subject.files)
        .not_to include(*removed)
    end
  end

  describe '#empty?' do
    context 'when no changes registered' do
      it 'returns true' do
        expect(empty_subject).to be_empty
      end
    end

    context 'when only removed files are present' do
      it 'returns true' do
        expect(removed_only_subject).to be_empty
      end
    end

    context 'when added or modified files are present' do
      it 'returns false' do
        expect(changed_subject).not_to be_empty
      end
    end
  end

  describe '#any?' do
    context 'when no actionable files exist' do
      it 'returns false' do
        expect(empty_subject).not_to be_any
        expect(removed_only_subject).not_to be_any
      end
    end

    context 'when actionable files exist' do
      it 'returns true' do
        expect(changed_subject).to be_any
      end
    end
  end

  describe '#to_h' do
    it 'returns a hash of all changes and files' do
      expect(changed_subject.to_h).to eq(
        {
          added:    added,
          removed:  removed,
          modified: modified,
          files:    added + modified,
        }
      )
    end
  end

  describe '#each' do
    context 'when no block is given' do
      it 'returns an enumerator' do
        expect(changed_subject.each).to be_an(Enumerator)
      end

      it 'returns all changes' do
        expect(changed_subject.each.to_a).to match_array(events)
      end
    end

    context 'when a block is given' do
      it 'yields each change with its type and path' do
        yielded = changed_subject.each.map do |type, path|
          [type, path]
        end

        expect(yielded).to match_array(events)
      end
    end
  end
end
