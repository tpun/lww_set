require 'rspec'
require_relative './lww_set'

describe 'LWWSet' do
  describe '#add' do
    context 'when adding an element' do
      before(:each) do
        @lww = LWWSet.new
        @data = 'blah'
        @timestamp = 10000
        @lww.add(@data, @timestamp)
      end

      it 'adds to add_set' do
        @lww.add_set.should have(1).items
      end

      it 'is idempotent' do
        @lww.add(@data, @timestamp)
        @lww.add_set.should have(1).items
      end
    end
  end

  describe '#remove' do
    it 'adds element to remove_set'
  end

  describe '#set' do
    it 'removes previously added element only if removal happens after'
    it 'adds previously removed element only if addition happens after'
    it 'gives bias to addition'
    it 'returns a set'
  end
end
