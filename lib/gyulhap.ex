defmodule Gyulhap do
  @moduledoc """
  Documentation for Gyulhap.
  """

  alias Gyulhap.Element

  @type solution :: {integer, integer, integer}

  @doc """
  Generate Problem table randomly
  """
  @spec generate_table() :: [Element.t]
  def generate_table do
    Enum.map(1..9, &Element.generate/1)
  end

  @doc """
  Find all solutions from table
  """
  @spec solutions([Element.t]) :: [solution]
  def solutions(table) do
    for x <- table, y <- table, z <- table,
        x.idx < y.idx, y.idx < z.idx,
        solution?([x, y, z]) do
      {x.idx, y.idx, z.idx}
    end
  end

  defp solution?(ss) do
    Enum.all?([:shape, :bg_color, :color], &matched?(ss, &1))
  end

  defp matched?(structs, key) do
    list = structs |> Enum.map(&Map.get(&1, key))
    case list do
      [a, a, a] -> true
      [a, a, _] -> false
      [_, a, a] -> false
      [a, _, a] -> false
      _ -> true
    end
  end

  @doc """
  Check given solution is included in actual solutions or not
  """
  @spec judge?([solution], [solution], solution) :: boolean
  def judge?(solutions, used_solutions, solution) do
    expected = sort(solution)
    Enum.member?(solutions, expected) && !Enum.member?(used_solutions, expected)
  end

  def sort({a, b, c}) do
    [a, b, c]
    |> Enum.sort()
    |> List.to_tuple()
  end
end
