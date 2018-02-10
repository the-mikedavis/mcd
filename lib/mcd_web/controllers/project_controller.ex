defmodule McdWeb.ProjectController do
  use McdWeb, :controller

  alias Mcd.Content

  def index(conn, _params) do
    projects = Content.list_projects()
    render(conn, "index.html", projects: projects)
  end

  def show(conn, %{"id" => id}) do
    project = Content.get_project!(id)
    render(conn, "show.html", project: project)
  end
end
