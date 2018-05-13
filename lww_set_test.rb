require 'rspec'
require_relative './lww_set'

describe 'LWWSet' do
  before(:each) do
    @lww = LWWSet.new
    @data = 'blah'
    @epoch = Time.now.to_i/2
  end

  describe '.initialize' do
    it 'raises an error if bias is not one of BIAS_ADDS or BIAS_REMOVALS' do
      expect{ LWWSet.new(100) }.to raise_error(/Invalid bias:/)
    end
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

    it 'honors bias on same-time events' do
      lww_bias_add = LWWSet.new(LWWSet::BIAS_ADDS)
      lww_bias_add.add(@data, @epoch)
      lww_bias_add.remove(@data, @epoch)
      expect(lww_bias_add.set).to contain_exactly(@data)

      lww_bias_removal = LWWSet.new(LWWSet::BIAS_REMOVALS)
      lww_bias_removal.add(@data, @epoch)
      lww_bias_removal.remove(@data, @epoch)
      expect(lww_bias_removal.set).to be_empty
    end

    it 'returns a set' do
      expect(@lww.set.class).to be(Set)
    end
  end
end
