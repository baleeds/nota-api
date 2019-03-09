defmodule Nota.Bible do
  import Ecto.Query, warn: false

  alias Nota.Repo
  alias Nota.Bible.Verse

  def get_verse(id), do: Repo.get(Verse, id)

  # def get_verses(%{chapter_id: chapter_id, book_id: book_id}) do
  #   query = from v in Verse,
  #     where: v.chapter == chapter_id,
  #     where: v.book == book_id

  #   Repo.all(query)
  # end

  def get_verses(%{chapter_id: chapter_id, book_id: book_id}) do
    Verse
    |> where([v], v.book_id == ^book_id)
    |> where([v], v.chapter_id == ^chapter_id)
    |> Repo.all
  end

  def get_verses(_) do
    {:error, "invalid query for verses"}
  end
end