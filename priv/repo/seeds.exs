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
alias Mcd.Content.Topic

insert = fn str ->
  Repo.get_by(Topic, name: str) || Repo.insert!(%Topic{name: str})
end

"priv/content/knowledge.json"
|> File.read!
|> Poison.decode!()
|> Enum.each(insert)
