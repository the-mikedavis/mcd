defmodule McdWeb.VigiloView do
  use McdWeb, :view

  def render("update.json", %{status: stat}) do
    %{status: stat}
  end

  def ecto_time_as_string(nil), do: "never"
  def ecto_time_as_string(time) do
    Ecto.DateTime.to_string(time) 
  end
end
