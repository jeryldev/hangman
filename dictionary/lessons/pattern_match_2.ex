defmodule PatternMatch2 do
  def equal({a, a}), do: true
  def equal({_, _}), do: false
end
