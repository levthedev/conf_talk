class Calculator
  def add(*args)
    :+.to_proc.call(*args)
  end
end
