class Calculator
  operators = {:+ => "add", :- => "subtract", :* => "multiply", :/ => "divide"}

  operators.each do |sym, str|
    define_method("#{str}") do |*tuple|
      p sym.to_proc.call(*tuple)
    end
  end
end

c = Calculator.new
c.add 10, 2
c.subtract 10, 2
c.multiply 10, 2
c.divide 10, 2
