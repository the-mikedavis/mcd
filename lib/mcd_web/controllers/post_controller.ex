defmodule McdWeb.PostController do
  use McdWeb, :controller

  alias Mcd.Content.Repo

  def index(conn, _params) do
    {:ok, posts} = Repo.list()
    render(conn, "index.html", posts: posts)
  end

  def show(conn, %{"id" => id}) do
    case Repo.get_by_slug(id) do
      {:ok, post} -> render(conn, "show.html", post: post)
      :not_found -> not_found(conn)
    end
  end

  def not_found(conn) do
    conn
    |> put_status(:not_found)
    |> render(McdWeb.ErrorView, "404.html")
  end
end
