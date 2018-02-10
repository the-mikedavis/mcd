# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Mcd.Repo.insert!(%Mcd.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Mcd.Repo
alias Mcd.Content.Project

read = fn name ->
  "priv/content/" <> name <> ".json"
  |> File.read!()
  |> Poison.decode!(as: %Project{})
end

insert = fn (%Project{title: t} = p) ->
  Repo.get_by(Project, title: t) || Repo.insert!(p)
end

~w(attendance)
|> Enum.map(read)
|> Enum.each(insert)

