defmodule Mcd.Attendance do
  use GenServer

  @moduledoc """
  Attendance from Vigilo.
  """

  def start_link do
    GenServer.start_link(__MODULE__, {[], nil}, name: :attendant)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(:status, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:update, devices}, _state) do
    time =
      "EDT"
      |> Timex.now()
      |> Timex.format!("{ISOdate} {ISOtime}")

    {:noreply, {devices, time}}
  end
end
