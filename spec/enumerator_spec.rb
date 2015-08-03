require_relative '../lib/enumerator.rb'

RSpec.describe 'MyEnumerable' do
  def expect_enum(array, method_name, *args, expected, &block)
    actual = MyEnumerator.new(array).__send__(method_name, *args, &block)
    expect(actual).to eq expected
  end

  describe 'count' do
    specify 'returns how many items the block returns true for' do
      expect_enum([],              :count, 0) { true }
      expect_enum(['a', 'a'],      :count, 2) { true }
      expect_enum(['a', 'b', 'a'], :count, 2) { |char| char == 'a' }
    end

    specify 'returns how many items are in the array, if no block is given' do
      expect_enum [],         :count, 0
      expect_enum ['a'],      :count, 1
      expect_enum ['a', 'a'], :count, 2
    end
  end

  specify 'find_all returns all the items where the block returns true' do
    expect_enum([], :find_all, []) { true }
    expect_enum([], :find_all, []) { false }

    ary = [1,2,1,3,2,6]
    expect_enum(ary, :find_all,       ary) { true }
    expect_enum(ary, :find_all,        []) { false }
    expect_enum(ary, :find_all, [1, 1, 3]) { |i| i.odd? }
    expect_enum(ary, :find_all, [2, 2, 6]) { |i| i.even? }
  end

  specify 'map returns an array of elements that have been passed through the block' do
    expect_enum([],         :map,         []) { 1 }
    expect_enum(['a', 'b'], :map,     [1, 1]) { 1 }
    expect_enum(['a', 'b'], :map, ['A', 'B']) { |char| char.upcase }
  end

  specify 'map with no block returns a MyEnumerator object which can be chained with more enums' do
    my_enum = MyEnumerator.new(['a', 'b']).map
    expect(my_enum.class).to eq(MyEnumerator)
    expect(my_enum.with_index { |e, i| "#{e}#{i}"}).to eq(["a0", "b1"])
  end

  specify 'next returns the next element' do
    my_enum = MyEnumerator.new(['a', 'b'])
    expect(my_enum.next).to eq('a')
    expect(my_enum.next).to eq('b')
  end

  specify 'each iterates over each element and returns original collection' do
    arr = []
    second_enum = MyEnumerator.new([1, 2, 3])
    each_result = second_enum.each { |e| arr << e ** 2 }

    expect(each_result).to eq([1, 2, 3])
    expect(arr).to eq([1, 4, 9])
  end
end
