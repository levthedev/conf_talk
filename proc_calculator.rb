class Calculator
  [:+, :-, :*, :/].each do |sym|
    operators = {:+ => "add", :- => "subtract", :* => "multiply", :/ => "divide"}
    define_method("#{operators[sym]}") do |*tuple|
      p sym.to_proc.call(*tuple)
    end
  end
end

c = Calculator.new
c.add 10, 2
c.subtract 10, 2
c.multiply 10, 2
c.divide 10, 2
