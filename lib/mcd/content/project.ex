defmodule Mcd.Content.Project do
  use Ecto.Schema
  import Ecto.Changeset
  alias Mcd.Content.Project


  schema "projects" do
    field :content, :string
    field :description, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(%Project{} = project, attrs) do
    project
    |> cast(attrs, [:title, :content, :description])
    |> validate_required([:title, :content, :description])
  end
end
