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
    it 'object with the same data and timestamp is considered identical' do
      @another = TimestampedElement.new(@element.data, @element.timestamp)
      set = Set.new
      set.add(@element)
      set.add(@another)
      expect(set.size).to be(1)
    end
  end

  context 'when deleting from a set' do
    it 'object with the same data and timestamp is considered identical' do
      @another = TimestampedElement.new(@element.data, @element.timestamp)
      set = Set.new
      set.add(@element)
      set.delete(@another)
      expect(set.size).to be(0)
    end
  end
end
