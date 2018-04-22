class TimestampedElement
  include Comparable
  attr_reader :index

  def initialize(data, timestamp)
    @data = data
    @timestamp = timestamp
    @index = TimestampedElementIndex.generate(@data, @timestamp)
  end

  def <=>(another)
  end
end

class TimestampedElementIndex
  def self.generate(data, timestamp)
    return ''
  end
end
