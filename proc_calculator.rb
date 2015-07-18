class Calculator
  def add(*tuple)
    p :+.to_proc.call(*tuple)
  end

  def subtract(*tuple)
    p :-.to_proc.call(*tuple)
  end

  def multiply(*tuple)
    p :*.to_proc.call(*tuple)
  end

  def divide(*tuple)
    p :/.to_proc.call(*tuple)
  end
end

c = Calculator.new
c.add 10, 2
c.subtract 10, 2
c.multiply 10, 2
c.divide 10, 2

