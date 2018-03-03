defmodule Mcd.Content.Crawler do
  alias Mcd.Content.Post

  def crawl do
    File.ls!("priv/posts")
    |> Enum.map(&Post.compile/1)
    |> Enum.sort(&sort/2)
  end

  def sort(a, b) do
    Time.compare(a.date, b.date) > 0
  end
end
