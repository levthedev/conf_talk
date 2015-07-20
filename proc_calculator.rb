class Calculator
  operators = {:+ => "add", :- => "subtract", :* => "multiply", :/ => "divide"}  # => {:+=>"add", :-=>"subtract", :*=>"multiply", :/=>"divide"}

  operators.each do |sym, str|           # => {:+=>"add", :-=>"subtract", :*=>"multiply", :/=>"divide"}
    define_method("#{str}") do |*tuple|
      sym.to_proc.call(*tuple)           # => 12, 8, 20, 5
    end                                  # => :add, :subtract, :multiply, :divide
  end                                    # => {:+=>"add", :-=>"subtract", :*=>"multiply", :/=>"divide"}
end

c = Calculator.new  # => #<Calculator:0x007fcc6b030e00>
c.add 10, 2         # => 12
c.subtract 10, 2    # => 8
c.multiply 10, 2    # => 20
c.divide 10, 2      # => 5
