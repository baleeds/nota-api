defmodule Nota.Bible do
  import Ecto.Query, warn: false

  alias Nota.Repo
  alias Nota.Bible.Verse

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end

  def get_verse(id), do: Repo.get(Verse, id)

  # def get_verses(%{chapter_number: chapter_number, book_number: book_number}) do
  #   query = from v in Verse,
  #     where: v.chapter == chapter_number,
  #     where: v.book == book_number

  #   Repo.all(query)
  # end

  def get_verses(%{chapter_number: chapter_number, book_number: book_number}) do
    Verse
    |> where([v], v.book_number == ^book_number)
    |> where([v], v.chapter_number == ^chapter_number)
    |> Repo.all
  end

  def get_verses(_) do
    {:error, "invalid query for verses"}
  end
end