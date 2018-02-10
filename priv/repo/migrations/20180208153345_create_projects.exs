defmodule Mcd.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :title, :string
      add :content, :text
      add :description, :text

      timestamps()
    end

  end
end
