require 'rspec'
require_relative './lww_set'

describe 'LWWSet' do
  before(:each) do
    @lww = LWWSet.new
    @data = 'blah'
    @timestamp = Time.now -  1000
  end
  describe '#add' do
    context 'when adding an element' do
      it 'adds to add_set' do
        @lww.add(@data, @timestamp)
        expect(@lww.add_set.size).to be(1)
      end

      it 'is idempotent' do
        @lww.add(@data, @timestamp)
        @lww.add(@data, @timestamp)
        expect(@lww.add_set.size).to be(1)
      end
    end
  end

  describe '#remove' do
    context 'when removing an element' do
      it 'adds element to remove_set' do
        @lww.remove(@data, @timestamp)
        expect(@lww.remove_set.size).to be(1)
      end
    end
  end

  describe '#set' do
    it 'removes previously added element only if removal happens after' do
      @lww.add(@data, @timestamp)
      another_data = 'nah'
      @lww.add(another_data, @timestamp+10)
      expect(@lww.set).to contain_exactly(@data, another_data)

      @lww.remove(@data, @timestamp+20)
      expect(@lww.set).to contain_exactly(another_data)
    end

    it 'adds previously removed element only if addition happens after' do
      @lww.add(@data, @timestamp)
      @lww.remove(@data, @timestamp+10)
      expect(@lww.set.size).to be(0)

      another_data = 'nah'
      @lww.add(another_data, @timestamp+20)
      @lww.add(@data, @timestamp+30)
      expect(@lww.set).to contain_exactly(@data, 'nah')
    end

    it 'gives bias to addition' do
      @lww.add(@data, @timestamp)
      @lww.remove(@data, @timestamp)
      expect(@lww.set).to contain_exactly(@data)
    end

    it 'returns a set' do
      expect(@lww.set.class).to be(Set)
    end
  end
end
