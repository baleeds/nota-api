defmodule Nota.VerseFavorites do
  @moduledoc """
  The VerseFavorites context.
  """

  import Ecto.Query, warn: false
  alias Nota.Repo

  alias Nota.VerseFavorites.VerseFavorite

  def create_verse_favorite(attrs \\ %{}) do
    %VerseFavorite{}
    |> VerseFavorite.changeset(attrs)
    |> Repo.insert()
  end

  def delete_verse_favorite(%VerseFavorite{} = verse_favorite) do
    Repo.delete(verse_favorite)
  end
end
