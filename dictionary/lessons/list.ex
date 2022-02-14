defmodule Lists do
  require Integer

  # [] = 0
  # [ 1, 3, 5] => 3

  def len([]), do: 0
  def len([_h | t]), do: 1 + len(t)

  # [] = 0
  # [ 1, 3, 5] => 9

  def sum([]), do: 0
  def sum([h | t]), do: h + sum(t)

  # [] = 0
  # [ 1, 3, 5] => [ 1, 9, 25]

  def square([]), do: []
  def square([h | t]), do: [h * h | square(t)]

  # [] = 0
  # [ 1, 3, 5] => [ 1, 9, 25]

  def double([]), do: []
  def double([h | t]), do: [2 * h | square(t)]

  # Lists.map [1,2,3,4], fn x -> x*2 end = [2, 4, 6, 8]
  # Lists.map [1,2,3,4], &(&1 * 5) = [5, 10, 15, 20]
  def map([], _func) do
    []
  end

  def map([h | t], func) do
    [func.(h) | map(t, func)]
  end

  def sum_pairs([]) do
    []
  end

  def sum_pairs([h1, h2 | t]) do
    [h1 + h2 | sum_pairs(t)]
  end

  def even_length([]) do
    0
  end

  def even_length([_h | t]) do
    list_length = 1 + len(t)
    Integer.is_even(list_length)
  end
end
