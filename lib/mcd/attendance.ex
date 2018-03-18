defmodule Mcd.Attendance do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: :attendant)
  end

  def init(state) do
    { :ok, state }
  end

  def handle_call(:devices, _from, state) do
    { :reply, state, state }
  end

  def handle_cast({ :update, devices }, _state) do
    { :noreply, devices }
  end
end
