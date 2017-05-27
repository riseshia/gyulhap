defmodule GyulhapTest do
  use ExUnit.Case

  test "judge?" do
    solutions = [{1, 2, 3}, {2, 3, 4}, {4, 5, 6}]

    assert Gyulhap.judge?(solutions, [], {2, 3, 4})
    assert Gyulhap.judge?(solutions, [], {3, 2, 1})
    refute Gyulhap.judge?(solutions, [], {1, 2, 5})
    refute Gyulhap.judge?(solutions, [{2, 3, 4}], {2, 3, 4})
  end

  test "solutions" do
    table = [
      %Gyulhap.Element{bg_color: :white, color: :red, idx: 1, shape: :rectangle},
      %Gyulhap.Element{bg_color: :white, color: :yellow, idx: 2, shape: :rectangle},
      %Gyulhap.Element{bg_color: :gray, color: :yellow, idx: 3, shape: :triangle},
      %Gyulhap.Element{bg_color: :white, color: :blue, idx: 4, shape: :rectangle},
      %Gyulhap.Element{bg_color: :gray, color: :yellow, idx: 5, shape: :rectangle},
      %Gyulhap.Element{bg_color: :black, color: :yellow, idx: 6, shape: :triangle},
      %Gyulhap.Element{bg_color: :black, color: :red, idx: 7, shape: :rectangle},
      %Gyulhap.Element{bg_color: :black, color: :red, idx: 8, shape: :triangle},
      %Gyulhap.Element{bg_color: :gray, color: :blue, idx: 9, shape: :triangle}
    ]

    assert Gyulhap.solutions(table) == [{1, 2, 4}, {4, 5, 7}]
  end
end
