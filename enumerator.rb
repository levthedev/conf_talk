require 'fiber'

module MyEnumerable
  def to_a
    each {|e| [] << e}
  end

  def count(&block)
    block ||= Proc.new { true }
    count = 0
    each {|e| count += 1 if block.call(e) }
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
      MyEnumerator.new(@array)
    end
  end

  def to_h
    puts "this should return a hash"
  end
end

class MyEnumerator
  include MyEnumerable
  def initialize(array)
    @array = array
  end

  def each(&block)
    @array.each(&block)
  end

  def next
    @fiber ||= Fiber.new do
      each { |e| Fiber.yield(e) }
      raise StopIteration
    end
    @fiber.alive? ? @fiber.resume : raise(StopIteration)
   end
end

my_enum = MyEnumerator.new([1,2,3,4,5,6,7])
my_enum.map.count
real_enum = Enumerator.new([1,2,3,4,5,6,7])
real_enum.map.count

Enumerator.new([1,2]).next
MyEnumerator.new([1,2]).next
