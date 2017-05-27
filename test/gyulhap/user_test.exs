defmodule Gyulhap.UserTest do
  use ExUnit.Case
  alias Gyulhap.User

  test "score message" do
    User.start_link(2, :user1)
    assert 2 = GenServer.call(:user1, :score)
    assert 1 = GenServer.call(:user1, {:update_score, -1})
  end
end
