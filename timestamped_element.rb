class TimestampedElement
  attr_reader :data, :epoch

  def initialize(data, epoch)
    @data = data
    @epoch = epoch
  end

  # We need to implement #hash and #eql? so that objects with same
  # data and epoch will be considered the same when adding to a set.
  # https://stackoverflow.com/questions/2328685/how-to-make-object-instance-a-hash-key-in-ruby
  def hash
    [@data, @epoch].hash
  end

  def eql?(another)
    [@data, @epoch].eql? [another.data, another.epoch]
  end
end
