defmodule Gyulhap.Game do
  @moduledoc """
  Functions to handle Game
  Documentation for Gyulhap.
  """

  @type solution :: {integer, integer, integer}

  @spec init() :: map
  def init() do
    table = Gyulhap.generate_table()
    %{
      turn: 0,
      used_solutions: [],
      timeout_count: 0,
      is_finished: false,
      solutions: Gyulhap.solutions(table),
      table: table,
    }
  end

  def role_turn(state, user, answer) do
    cond do
      !turn_of?(state, user) ->
        {:not_turn, state}
      Gyulhap.judge?(state.solutions, state.used_solutions, answer) ->
        new_answer = Gyulhap.sort(answer)
        new_state = state
          |> add_solution(new_answer)
          |> Map.put(:timeout_count, 0)
          |> turn_start()
        {:success, new_state}
      true ->
        new_state = state
          |> Map.put(:timeout_count, 0)
          |> turn_start()
        {:fail, new_state}
    end
  end

  def timeout(state) do
    state
    |> turn_start()
    |> Map.update(:timeout_count, 0, &(&1 + 1))
  end

  defp turn_of?(state, user) do
    !state.is_finished &&
      :"user#{2 - rem(state.turn, 2)}" == user
  end

  def turn_start(state) do
    Map.update(state, :turn, 0, &(&1 + 1))
  end

  defp add_solution(state, solution) do
    Map.update(state, :used_solutions, [], &([solution | &1]))
  end
end
