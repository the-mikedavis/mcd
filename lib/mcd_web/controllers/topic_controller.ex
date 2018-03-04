defmodule McdWeb.TopicController do
  use McdWeb, :controller

  alias Mcd.Content

  def index(conn, _params) do
    topics = Content.list_topics()
    render(conn, "index.html", topics: topics)
  end
end
