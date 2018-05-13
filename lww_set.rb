require 'set'

class LWWSet
  TimestampedElement = Struct.new(:data, :epoch)

  attr_reader :add_set, :remove_set
  BIAS_ADDS = 0
  BIAS_REMOVALS = 1

  def initialize(bias=BIAS_ADDS)
    raise ("Invalid bias: %s" % bias) if bias!=BIAS_ADDS and bias!=BIAS_REMOVALS
    @bias = bias
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
    removal_record = @remove_set.find do |removed_element|
      removed_element.data == added_element.data &&
      removed_element.epoch <= until_epoch &&
      remove_by_bias?(added_element.epoch, removed_element.epoch)
    end
    removal_record != nil
  end

  # If the removal is recorded at the exact same time
  # as a addition, preference is given according to the bias
  def remove_by_bias?(addition_epoch, removal_epoch)
    case @bias
    when BIAS_ADDS
      return removal_epoch > addition_epoch
    when BIAS_REMOVALS
      return removal_epoch >= addition_epoch
    end
  end
end
