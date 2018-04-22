require 'rspec'
require_relative './timestamped_element'

describe 'TimestampedElement' do
  before(:each) do
    @data = 'blah'
    @timestamp = 10000
    @element = TimestampedElement.new(@data, @timestamp)
  end

  describe '#index' do
    it 'generates an index using TimestampedElementIndex' do
      @element.index.should eq(TimestampedElementIndex.generate(@data, @timestamp))
    end
  end

  context 'when comparing' do
    it 'is equal when both have same data and timestamp'
    it 'sorts by timestamp'
  end
end
