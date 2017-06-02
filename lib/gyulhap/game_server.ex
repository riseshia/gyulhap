defmodule Gyulhap.GameServer do
  use GenServer

  def init(_) do
    table = Gyulhap.generate_table()
    GenServer.start_link(Timer, 10, name: Timer)
    :timer.apply_interval(:timer.seconds(1), Timer, :tick, [])
    {:ok, %{
      turn: 0,
      used_solutions: [],
      timeout_count: 0,
      is_finished: false,
      solutions: Gyulhap.solutions(table),
      table: table,
    }}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:turn_start, _from, state) do
    new_state = turn_start(state)
    # reset_timer
    {:reply, new_state, new_state}
  end

  def handle_call({:answer, user, :hap, answer}, _from, state) do
    new_state =
      cond do
        !turn_of?(state, user) ->
          IO.puts "It's not your turn"
          state
        Gyulhap.judge?(state.solutions, state.used_solutions, answer) ->
          GenServer.call(user, {:update_score, 1})
          new_answer = Gyulhap.sort(answer)
          state
          |> add_solution(new_answer)
          |> Map.put(:timeout_count, 0)
          |> turn_start()
        true ->
          GenServer.call(user, {:update_score, -1})
          state
          |> Map.put(:timeout_count, 0)
          |> turn_start()
      end
    {:reply, new_state, new_state}
  end

  def handle_call(:timeout, _from, %{ timeout_count: 6 } = state) do
    new_state = Map.put(state, :is_finished, true)
    {:reply, new_state, new_state}
  end
  def handle_call(:timeout, _from, state) do
    new_state =
      state
      |> turn_start()
      |> Map.update(:timeout_count, 0, &(&1 + 1))
    {:reply, new_state, new_state}
  end

  defp turn_of?(state, user) do
    !state.is_finished &&
      :"user#{2 - rem(state.turn, 2)}" == user
  end

  defp turn_start(state) do
    Map.update(state, :turn, 0, &(&1 + 1))
  end

  defp add_solution(state, solution) do
    Map.update(state, :used_solutions, [], &([solution | &1]))
  end

  ### Client

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end
end
