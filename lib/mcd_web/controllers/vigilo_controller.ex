defmodule McdWeb.VigiloController do
  use McdWeb, :controller

  def index(conn, _params) do
    devs = GenServer.call(:attendant, :devices)
    render conn, "index.html", devices: devs
  end

  def update(conn, %{ "devices" => devices }) do
    GenServer.cast(:attendant, { :update, devices })
    render conn, "update.json", status: "success"
  end

  def update(conn, _) do
    render conn, "update.json", status: "failure"
  end
end
