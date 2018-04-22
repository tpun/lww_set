require 'set'
require_relative './timestamped_element'

class LWWSet
  attr_reader :add_set, :remove_set

  def initialize
    @add_set = Set.new
    @remove_set = Set.new
  end

  def add(data, timestamp=Time.now)
    element = TimestampedElement.new(data, timestamp)
    @add_set.add(element)
  end

  def remove(data, timestamp=Time.now)
    element = TimestampedElement.new(data, timestamp)
    @remove_set.add(element)
  end

  def set(at=Time.now)
    return Set.new
  end
end
