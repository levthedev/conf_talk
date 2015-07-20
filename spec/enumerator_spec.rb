require_relative '../lib/enumerator.rb'

RSpec.describe 'MyEnumerable' do
  def assert_enum(array, method_name, *args, expected, &block)
    actual = MyEnumerator.new(array).__send__(method_name, *args, &block)
    expect(actual).to eq expected
  end

  describe 'count' do
    specify 'returns how many items the block returns true for' do
      assert_enum([],              :count, 0) { true }
      assert_enum(['a', 'a'],      :count, 2) { true }
      assert_enum(['a', 'b', 'a'], :count, 2) { |char| char == 'a' }
    end

    specify 'returns how many items are in the array, if no block is given' do
      assert_enum [],         :count, 0
      assert_enum ['a'],      :count, 1
      assert_enum ['a', 'a'], :count, 2
    end
  end

  specify 'find_all returns all the items where the block returns true' do
    assert_enum([], :find_all, []) { true }
    assert_enum([], :find_all, []) { false }

    ary = [1,2,1,3,2,6]
    assert_enum(ary, :find_all,       ary) { true }
    assert_enum(ary, :find_all,        []) { false }
    assert_enum(ary, :find_all, [1, 1, 3]) { |i| i.odd? }
    assert_enum(ary, :find_all, [2, 2, 6]) { |i| i.even? }
  end

  specify 'map returns an array of elements that have been passed through the block' do
    assert_enum([],         :map,         []) { 1 }
    assert_enum(['a', 'b'], :map,     [1, 1]) { 1 }
    assert_enum(['a', 'b'], :map, ['A', 'B']) { |char| char.upcase }
  end

  specify 'map with no block returns a MyEnumerator object which can be chained' do
    expect(MyEnumerator.new(['a', 'b']).map.class).to eq(MyEnumerator)
    expect(MyEnumerator.new(['a', 'b']).map.with_index { |e, i| "#{e}#{i}"}).to eq(["a0", "b1"
      ])
  end
end
