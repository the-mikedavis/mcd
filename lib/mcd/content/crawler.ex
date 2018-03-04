defmodule Mcd.Content.Crawler do
  alias Mcd.Content.Post

  def crawl do
    File.ls!("priv/posts")
    |> Enum.map(fn(file) -> Task.async(fn -> Post.compile(file) end) end)
    |> Enum.map(&Task.await/1)
    |> Enum.sort(&sort/2)
  end

  def sort(a, b) do
    Time.compare(a.date, b.date) > 0
  end
end
