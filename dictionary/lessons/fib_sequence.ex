defmodule FibSequence do
  def fib(0) do
  end

  def fib(1) do
    1
  end

  def fib(n) do
    fib(n - 1) + fib(n - 2)
  end
end
