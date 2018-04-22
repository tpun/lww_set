class TimestampedElement
  attr_reader :data, :timestamp

  def initialize(data, timestamp)
    @data = data
    @timestamp = timestamp
  end

  # We need to implement #hash and #eql? so that objects with same
  # data and timestamp will be considered the same when adding to a set.
  # https://stackoverflow.com/questions/2328685/how-to-make-object-instance-a-hash-key-in-ruby
  def hash
    [@data, @timestamp].hash
  end

  def eql?(another)
    [@data, @timestamp].eql? [another.data, another.timestamp]
  end
end
