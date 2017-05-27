defmodule Gyulhap.GameTest do
  use ExUnit.Case
  alias Gyulhap.Game
  alias Gyulhap.User

  test "state message" do
    User.start_link(0, :user1)
    User.start_link(0, :user2)
    Game.start_link()

    assert %{
      turn: 0,
      used_solutions: [],
      timeout_count: 0,
      table: table,
      solutions: solutions
    } = GenServer.call(Game, :state)
    assert 9 == length(table)

    assert %{ turn: 1 } = GenServer.call(Game, :turn_start)

    answer = hd(solutions)

    assert %{
      turn: 1,
      used_solutions: []
    } = GenServer.call(Game, {:answer, :user2, :hap, answer})
    assert %{
      turn: 2,
      used_solutions: [^answer]
    } = GenServer.call(Game, {:answer, :user1, :hap, answer})
    assert %{
      turn: 3,
      used_solutions: [^answer]
    } = GenServer.call(Game, {:answer, :user2, :hap, answer})
    Process.sleep 12000
    assert %{ timeout_count: 1 } = GenServer.call(Game, :state)
  end
end
