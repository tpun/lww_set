require 'set'

class LWWSet
  attr_reader :add_set, :remove_set

  def initialize
    @add_set = Set.new
    @remove_set = Set.new
  end

  def add(data, timestamp=Time.now)
  end

  def remove(data, timestamp=Time.now)
  end

  def set(at=Time.now)
    return Set.new
  end
end
