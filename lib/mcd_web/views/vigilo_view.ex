defmodule McdWeb.VigiloView do
  use McdWeb, :view

  def render("update.json", %{status: stat}) do
    %{status: stat}
  end

  def recognize_time(nil), do: "never"
  def recognize_time(time), do: time
end
