defmodule Timer do
  use GenServer
  alias Gyulhap.Game

  def init(time), do: {:ok, time}

  def handle_call(:reset_timer, _from, _remain) do
    {:reply, 10, 10}
  end

  def handle_call(:tick, _from, 0) do
    GenServer.call(Game, :timeout)
    {:reply, 10, 10}
  end
  def handle_call(:tick, _from, remain) do
    {:reply, remain - 1, remain - 1}
  end

  def tick() do
    GenServer.call(Timer, :tick)
  end
end
