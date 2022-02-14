defmodule PatternMatch1 do
  require Logger
  def swap({a, b}), do: {b, a}

  def sample(t = {a, b}) do
    IO.puts("a = #{a}, b = #{b}, #{is_tuple(t)}")
  end

  def sample2({:ok, value}) do
    IO.puts("sample worked! Value: #{value}")
  end

  def sample2({:error, reason}) do
    IO.puts("sample worked! Reason: #{reason}")
  end

  def read_file({:ok, file}) do
    file
    |> IO.read(:line)
  end

  def read_file({:error, reason}) do
    Logger.error("File error: #{reason}")
    []
  end
end
