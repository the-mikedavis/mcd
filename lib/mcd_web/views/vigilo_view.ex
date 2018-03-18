defmodule McdWeb.VigiloView do
  use McdWeb, :view

  def render("update.json", %{status: stat}) do
    %{status: stat}
  end
end
