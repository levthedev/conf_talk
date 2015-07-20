require 'fiber'

module MyEnumerable
  def to_a
    each { |e| [] << e }
  end

  def count(&block)
    block ||= Proc.new { true }
    count = 0
    each { |e| count += 1 if block.call(e) }
    count
  end

  def find(&block)
    each { |e| return e if block.call(e) }
    nil
  end

  def find_all(&block)
    array = []
    each { |e| array << e if block.call(e) }
    array
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
  end

  def next
    index = 0
    @fiber ||= Fiber.new do
      self.collection.length.times do |e|
        Fiber.yield(collection[index])
        index += 1
      end
      raise StopIteration
    end
    @fiber.alive? ? @fiber.resume : raise(StopIteration)
   end
end

my_enum = MyEnumerator.new [1, "hi"]
my_enum.map
my_enum.next
my_enum.next

real_enum = Enumerator.new [1, "hi"]
real_enum.map.count
real_enum.next
real_enum.next

Enumerator.new([1,2]).next
MyEnumerator.new([1,2]).next
