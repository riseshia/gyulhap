defmodule Gyulhap.GameServer do
  use GenServer
  alias Gyulhap.Game

  def init(_) do
    GenServer.start_link(Timer, 10, name: Timer)
    :timer.apply_interval(:timer.seconds(1), Timer, :tick, [])
    {:ok, Game.init()}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:turn_start, _from, state) do
    new_state = Game.turn_start(state)
    # reset_timer
    {:reply, new_state, new_state}
  end

  def handle_call({:answer, user, :hap, answer}, _from, state) do
    new_state =
      case Game.role_turn(state, user, answer) do
        {:not_turn, new_state} ->
          IO.puts "It's not your turn"
          new_state
        {:success, new_state} ->
          GenServer.call(user, {:update_score, 1})
          new_state
        {:fail, new_state} ->
          GenServer.call(user, {:update_score, -1})
          new_state
      end
    {:reply, new_state, new_state}
  end

  def handle_call(:timeout, _from, %{ timeout_count: 6 } = state) do
    new_state = Map.put(state, :is_finished, true)
    {:reply, new_state, new_state}
  end
  def handle_call(:timeout, _from, state) do
    new_state = Game.timeout(state)
    {:reply, new_state, new_state}
  end

  ### Client

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end
end
