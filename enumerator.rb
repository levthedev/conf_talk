module MyEnumerable
  def to_a
    each {|e| [] << e}
  end

  def count(&block)
    block ||= Proc.new { true }              # => #<Proc:0x007fc6b301f208@/Users/levkravinsky/Desktop/playground/enumerator.rb:7>
    count = 0                                # => 0
    each {|e| count += 1 if block.call(e) }  # => [1, 2, 3, 4, 5, 6, 7]
    count                                    # => 7
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
      MyEnumerator.new(@array)             # => #<MyEnumerator:0x007fc6b301fc08 @array=[1, 2, 3, 4, 5, 6, 7]>
    end                                    # => #<MyEnumerator:0x007fc6b301fc08 @array=[1, 2, 3, 4, 5, 6, 7]>
  end

  def to_h
    puts "this should return a hash"
  end
end

class MyEnumerator
  include MyEnumerable   # => MyEnumerator
  def initialize(array)
    @array = array       # => [1, 2, 3, 4, 5, 6, 7], [1, 2, 3, 4, 5, 6, 7], [1, 2]
  end

  def each(&block)
    @array.each(&block)  # => [1, 2, 3, 4, 5, 6, 7]
  end

  def next
    @fiber ||= Fiber.new do
      puts "I'm a fiber too"
      each { |e| Fiber.yield(e) }
      raise StopIteration
    end
    if @fiber.alive?
       puts "I'm a fiber"
       @fiber.resume
     else
       raise StopIteration
     end
   end
end

my_enum = MyEnumerator.new([1,2,3,4,5,6,7])  # => #<MyEnumerator:0x007fc6b310c6c0 @array=[1, 2, 3, 4, 5, 6, 7]>
my_enum.map.count                            # => 7
real_enum = Enumerator.new([1,2,3,4,5,6,7])  # => #<Enumerator: [1, 2, 3, 4, 5, 6, 7]:each>
real_enum.map.count                          # => 7

Enumerator.new([1,2])    # => #<Enumerator: [1, 2]:each>
MyEnumerator.new([1,2])  # => #<MyEnumerator:0x007fc6b301db10 @array=[1, 2]>
