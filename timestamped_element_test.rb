require 'rspec'
require 'set'
require_relative './timestamped_element'

describe 'TimestampedElement' do
  before(:each) do
    @data = 'blah'
    @timestamp = 10000
    @element = TimestampedElement.new(@data, @timestamp)
  end

  context 'when inserting into a set' do
    it 'objects with the same data and timestamp are considered identical' do
      @another = TimestampedElement.new(@element.data, @element.timestamp)
      set = Set.new
      set.add(@element)
      set.add(@another)
      expect(set.size).to be(1)
    end

    it 'objects with the same data but different timestamp are considered different' do
      @another = TimestampedElement.new(@element.data, @element.timestamp+1000)
      set = Set.new
      set.add(@element)
      set.add(@another)
      expect(set.size).to be(2)
    end
  end

  context 'when deleting from a set' do
    it 'objects with the same data and timestamp are considered identical' do
      @another = TimestampedElement.new(@element.data, @element.timestamp)
      set = Set.new
      set.add(@element)
      set.delete(@another)
      expect(set.size).to be(0)
    end

    it 'objects with the same data but different timestamp are considered different' do
      @another = TimestampedElement.new(@element.data, @element.timestamp+1000)
      set = Set.new
      set.add(@element)
      set.delete(@another)
      expect(set.size).to be(1)
    end
  end
end
