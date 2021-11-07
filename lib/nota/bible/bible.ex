defmodule Nota.Bible do
  import Ecto.Query, warn: false

  alias Nota.Repo
  alias Nota.Bible.Verse
  alias Nota.Bible.VerseFavorite

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end

  def verse_favorite_data() do
    Dataloader.Ecto.new(Repo, query: &verse_favorite_query/2)
  end

  def verse_favorite_query(queryable, params) do
    IO.inspect(queryable)
    IO.inspect(params)

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
    |> where(book_number: ^book_number, chapter_number: ^chapter_number)
    |> Repo.all()
  end

  def get_verses(_) do
    {:error, "invalid query for verses"}
  end

  def bookmark_verse(user_id, verse_id) do
    %VerseFavorite{}
    |> VerseFavorite.changeset(%{user_id: user_id, verse_id: verse_id})
    |> Repo.insert()
  end

  def unbookmark_verse(user_id, verse_id) do
    VerseFavorite
    |> where(user_id: ^user_id, verse_id: ^verse_id)
    |> Repo.Extensions.delete_one()
  end

  def is_verse_bookmarked(user_id, verse_id) do
    VerseFavorite
    |> where(user_id: ^user_id, verse_id: ^verse_id)
    |> Repo.one()
    |> case do
      nil -> {:ok, false}
      _ -> {:ok, true}
    end
  end
end
