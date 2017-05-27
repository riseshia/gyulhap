defmodule Gyulhap.User do
  use GenServer

  def init(score), do: {:ok, score}

  def handle_call(:score, _from, score) do
    {:reply, score, score}
  end

  def handle_call({:update_score, delta}, _from, score) do
    new_score = score + delta
    {:reply, new_score, new_score}
  end

  ### Client

  def start_link(score, name) do
    GenServer.start_link(__MODULE__, score, name: name)
  end
end
