module MyEnumerable
  def to_a
    each {|e| [] << e}
  end

  def count(&block)
    block ||= Proc.new { true }              # => #<Proc:0x007f82fa02baa0@/Users/levkravinsky/Desktop/playground/enumerator.rb:7>
    count = 0                                # => 0
    each {|e| count += 1 if block.call(e) }  # ~> NoMethodError: undefined method `each' for #<MyEnumerator:0x007f82fa030320 @array=[1, 2]>
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
    if block                               # => nil
      array = []
      each { |e| array << block.call(e) }
      array
    else
      MyEnumerator.new(@array)             # => #<MyEnumerator:0x007f82fa030320 @array=[1, 2]>
    end                                    # => #<MyEnumerator:0x007f82fa030320 @array=[1, 2]>
  end

  def to_h
    puts "this should return a hash"
  end
end

class MyEnumerator
  include MyEnumerable   # => MyEnumerator
  def initialize(array)
    @array = array       # => [1, 2]
  end

  def each(&block)
    @array.each(&block)
  end
  
  def next
    @fiber ||= Fiber.new do
      each { |e| Fiber.yield(e) }
      raise StopIteration
    end
    if @fiber.alive?
       @fiber.resume
     else
       raise StopIteration
     end
   end
end

class MyArray
   include MyEnumerable   # => MyArray
   def initialize(array)
     @array = array       # => [1, 2]
   end

   def each(&block)
     @array.each(&block)
   end
end


array = MyArray.new([1,2])  # => #<MyArray:0x007f82fa0308c0 @array=[1, 2]>
array.map.count
[1,2].map.count

# ~> NoMethodError
# ~> undefined method `each' for #<MyEnumerator:0x007f82fa030320 @array=[1, 2]>
# ~>
# ~> /Users/levkravinsky/Desktop/playground/enumerator.rb:9:in `count'
# ~> /Users/levkravinsky/Desktop/playground/enumerator.rb:71:in `<main>'
