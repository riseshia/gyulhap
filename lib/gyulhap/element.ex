defmodule Gyulhap.Element do
  @moduledoc"""
  """

  @type color :: :red | :blue | :yellow
  @type bg_color :: :white | :gray | :black
  @type shape :: :rectangle | :triangle | :circle
  @type t :: %Gyulhap.Element{idx: integer,
                             color: color,
                              bg_color: bg_color,
                              shape: shape}
  defstruct ~w(idx bg_color color shape)a

  @colors ~w(red blue yellow)a
  @bg_colors ~w(white gray black)a
  @shapes ~w(rectangle triangle circle)a

  @spec generate(integer) :: t
  def generate(idx) do
    %Gyulhap.Element{
      idx: idx,
      color: Enum.random(@colors),
      bg_color: Enum.random(@bg_colors),
      shape: Enum.random(@shapes),
    }
  end
end
