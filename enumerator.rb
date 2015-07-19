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
      array = []                           # => []
      each { |e| array << block.call(e) }  # ~> NoMethodError: undefined method `call' for nil:NilClass
      array
    else

  end

  def to_h
    puts "this should return a hash"
  end
end

class MyEnumerator
  include MyEnumerable   # => MyEnumerator
  def initialize(array)
    @array = array       # => [1, 2, 3]
  end

  def each(&block)
    @array.each(&block)
  end

  def next
    @fiber ||= Fiber.new do
      each { |e| Fiber.yield(e) }
      raise StopIteration
    end
    @fiber.alive? ? @fiber.resume : raise StopIteration
  end
end

MyEnumerator.new([1,2,3]).map

# ~> NoMethodError
# ~> undefined method `call' for nil:NilClass
# ~>
# ~> /Users/levkravinsky/Desktop/playground/enumerator.rb:26:in `block in map'
# ~> /Users/levkravinsky/Desktop/playground/enumerator.rb:42:in `each'
# ~> /Users/levkravinsky/Desktop/playground/enumerator.rb:42:in `each'
# ~> /Users/levkravinsky/Desktop/playground/enumerator.rb:26:in `map'
# ~> /Users/levkravinsky/Desktop/playground/enumerator.rb:60:in `<main>'
