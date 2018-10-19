defmodule McdWeb.VigiloController do
  use McdWeb, :controller

  def index(conn, _params) do
    {devs, time} = GenServer.call(:attendant, :status)
    render(conn, "index.html", devices: devs, time: time)
  end

  def update(conn, %{"_json" => devices}) do
    GenServer.cast(:attendant, {:update, devices})
    render(conn, "update.json", status: "success")
  end

  def update(conn, _) do
    render(conn, "update.json", status: "failure")
  end
end
