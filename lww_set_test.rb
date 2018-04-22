require 'rspec'
require_relative './lww_set'

describe 'LWWSet' do
  before(:each) do
    @lww = LWWSet.new
    @data = 'blah'
    @epoch = Time.now.to_i/2
  end
  
  describe '#add' do
    context 'when adding an element' do
      it 'adds to add_set' do
        @lww.add(@data, @epoch)
        expect(@lww.add_set.size).to be(1)
      end

      it 'is idempotent' do
        @lww.add(@data, @epoch)
        @lww.add(@data, @epoch)
        expect(@lww.add_set.size).to be(1)
      end
    end
  end

  describe '#remove' do
    context 'when removing an element' do
      it 'adds element to remove_set' do
        @lww.remove(@data, @epoch)
        expect(@lww.remove_set.size).to be(1)
      end
    end
  end

  describe '#set' do
    before(:each) do
      @another_data = 'nah'
    end

    it 'removes previously added element only if removal happens after' do
      @lww.add(@data, @epoch)
      @lww.add(@another_data, @epoch+10)
      expect(@lww.set).to contain_exactly(@data, @another_data)

      @lww.remove(@data, @epoch+20)
      expect(@lww.set).to contain_exactly(@another_data)
    end

    it 'adds previously removed element only if addition happens after' do
      @lww.add(@data, @epoch)
      @lww.remove(@data, @epoch+10)
      expect(@lww.set.size).to be(0)

      @lww.add(@another_data, @epoch+20)
      @lww.add(@data, @epoch+30)
      expect(@lww.set).to contain_exactly(@data, @another_data)
    end

    it 'ignores events past given epoch' do
      @lww.add(@data, @epoch)
      @lww.add(@another_data, @epoch+10)
      @lww.remove(@another_data, @epoch+50)
      expect(@lww.set(@epoch+40)).to contain_exactly(@data, @another_data)
      expect(@lww.set(@epoch+60)).to contain_exactly(@data)
    end

    it 'gives bias to addition' do
      @lww.add(@data, @epoch)
      @lww.remove(@data, @epoch)
      expect(@lww.set).to contain_exactly(@data)
    end

    it 'returns a set' do
      expect(@lww.set.class).to be(Set)
    end
  end
end
