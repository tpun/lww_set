require 'rspec'
require_relative './lww_set'

describe 'LWWSet' do
  before(:each) do
    @lww = LWWSet.new
    @data = 'blah'
    @timestamp = 10000
  end
  describe '#add' do
    context 'when adding an element' do
      it 'adds to add_set' do
        @lww.add(@data, @timestamp)
        @lww.add_set.should have(1).items
      end

      it 'is idempotent' do
        @lww.add(@data, @timestamp)
        @lww.add(@data, @timestamp)
        @lww.add_set.should have(1).items
      end
    end
  end

  describe '#remove' do
    context 'when removing an element' do
      it 'adds element to remove_set' do
        @lww.remove(@data, @timestamp)
        @lww.remove_set.should have(1).items
      end
    end
  end

  describe '#set' do
    it 'removes previously added element only if removal happens after'
    it 'adds previously removed element only if addition happens after'
    it 'gives bias to addition'
    it 'returns a set'
  end
end
