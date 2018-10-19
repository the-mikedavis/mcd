defmodule Mcd.Content.Crawler do
  alias Mcd.Content.Post

  @moduledoc """
  Crawls the posts directory to compile posts.
  """

  def crawl() do
    find()
    |> Enum.map(fn file -> Task.async(fn -> Post.compile(file) end) end)
    |> Enum.map(&Task.await/1)
    |> Enum.sort(&sort/2)
  end

  def sort(a, b) do
    Time.compare(a.date, b.date) > 0
  end

  def find() do
    File.ls!("priv/posts")
    |> Enum.filter(&Regex.run(~r/.*\.md$/, &1))
  end
end
