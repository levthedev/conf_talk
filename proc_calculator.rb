class Calculator
  def add(*args)
    puts :+.to_proc.call(*args)
  end
end

c = Calculator.new
c.add(1, 2)
