defmodule Gyulhap.GameTest do
  use ExUnit.Case
  alias Gyulhap.Game

  test "role_turn" do
    state = Map.put(Game.init(), :solutions, [{1, 2, 3}])

    assert {:not_turn, state} = Game.role_turn(state, :user1, {1, 2, 3})
    assert {:success, %{timeout_count: 0, used_solutions: [{1, 2, 3}]}} =
           Game.role_turn(state, :user2, {1, 2, 3})
    assert {:fail, %{timeout_count: 0, used_solutions: []}} =
           Game.role_turn(state, :user2, {4, 5, 6})
  end
end
