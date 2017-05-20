defmodule Gyulhap.Element do
  @moduledoc"""
  """

  alias Gyulhap.Element

  @type color :: :red | :blue | :yellow
  @type bg_color :: :white | :gray | :black
  @type shape :: :rectangle | :triangle | :circle
  @type t :: %Element{color: color,
                      bg_color: bg_color,
                      shape: shape}
  defstruct ~w(idx bg_color color shape)a

  @colors ~w(red blue yellow)a
  @bg_colors ~w(white gray black)a
  @shapes ~w(rectangle triangle circle)a

  @spec generate(integer) :: t
  def generate(idx) do
    %Element{
      idx: idx,
      color: Enum.random(@colors),
      bg_color: Enum.random(@bg_colors),
      shape: Enum.random(@shapes),
    }
  end
end

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
  @spec judge?([solution], solution) :: boolean
  def judge?(solutions, solution) do
    expected = sort(solution)
    Enum.member?(solutions, expected)
  end

  defp sort({a, b, c}) do
    [a, b, c]
    |> Enum.sort()
    |> List.to_tuple()
  end
end
