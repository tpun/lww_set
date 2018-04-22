require 'rspec'
require 'set'
require_relative './timestamped_element'

describe 'TimestampedElement' do
  before(:each) do
    @data = 'blah'
    @epoch = 10000
    @element = TimestampedElement.new(@data, @epoch)
  end

  context 'when inserting into a set' do
    it 'objects with the same data and epoch are considered identical' do
      @another = TimestampedElement.new(@element.data, @element.epoch)
      set = Set.new
      set.add(@element)
      set.add(@another)
      expect(set.size).to be(1)
    end

    it 'objects with the same data but different epoch are considered different' do
      @another = TimestampedElement.new(@element.data, @element.epoch+1000)
      set = Set.new
      set.add(@element)
      set.add(@another)
      expect(set.size).to be(2)
    end
  end

  context 'when deleting from a set' do
    it 'objects with the same data and epoch are considered identical' do
      @another = TimestampedElement.new(@element.data, @element.epoch)
      set = Set.new
      set.add(@element)
      set.delete(@another)
      expect(set.size).to be(0)
    end

    it 'objects with the same data but different epoch are considered different' do
      @another = TimestampedElement.new(@element.data, @element.epoch+1000)
      set = Set.new
      set.add(@element)
      set.delete(@another)
      expect(set.size).to be(1)
    end
  end
end
