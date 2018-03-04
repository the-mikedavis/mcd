defmodule McdWeb.TopicView do
  use McdWeb, :view

  def sort(topics) do
    Enum.sort(topics, fn a, b ->
      a.name <= b.name
    end)
  end
end
