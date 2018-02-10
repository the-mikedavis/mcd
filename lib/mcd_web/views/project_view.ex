defmodule McdWeb.ProjectView do
  use McdWeb, :view

  def as_html(text) do
    Phoenix.HTML.raw(text)
  end
end
