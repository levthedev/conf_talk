require 'fiber'
require 'benchmark'

module MyEnumerable
  def count(&block)
    block ||= Proc.new { true }
    count = 0
    each { |e| count += 1 if block.call(e) }
    count
  end

  def find_all(&block)
    if block
      array = []
      each { |e| array << e if block.call(e) }
      array
    else
      MyEnumerator.new(@collection)
    end
  end

  def map(&block)
    if block
      array = []
      each { |e| array << block.call(e) }
      array
    else
      MyEnumerator.new(@collection)
    end
  end
end

class MyEnumerator
  include MyEnumerable
  attr_reader :collection

  def initialize(collection)
    @collection = collection
  end

  def each(&block)
    @collection.length.times {
      block.call(self.next)
    }
    @collection
  end

  def next
    index = 0
    @fiber ||= Fiber.new do
      self.collection.length.times do |e|
        Fiber.yield(collection[index])
        index += 1
      end
    end
    @fiber.resume if @fiber.alive?
   end

   def with_index(&block)
     index = -1
     map do |*elements|
       index += 1
       block.call *elements, index
     end
   end
end
