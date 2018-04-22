require 'set'
require_relative './timestamped_element'

class LWWSet
  attr_reader :add_set, :remove_set

  def initialize
    @add_set = Set.new
    @remove_set = Set.new
  end

  def add(data, epoch=Time.now.to_i)
    element = TimestampedElement.new(data, epoch)
    @add_set.add(element)
  end

  def remove(data, epoch=Time.now.to_i)
    element = TimestampedElement.new(data, epoch)
    @remove_set.add(element)
  end

  def set(until_epoch=Time.now.to_i)
    final_elements = @add_set.select do |added_element|
      added_element.epoch <= until_epoch &&
      !remove_later?(added_element, until_epoch)
     end
    Set.new(final_elements.map(&:data))
  end

  private
  def remove_later?(added_element, until_epoch=Time.now.to_i)
    # if the removal is recorded at the exact same time
    # as a addition, preference is given to addition, i.e.,
    # an element is only deletered if there is a removal
    # AFTER the addition's time
    removal_record = @remove_set.find do |removed_element|
      removed_element.data == added_element.data &&
      removed_element.epoch <= until_epoch &&
      removed_element.epoch > added_element.epoch
    end
    removal_record != nil
  end
end
