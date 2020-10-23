defmodule Nota.VerseFavoritesTest do
  use Nota.DataCase

  alias Nota.VerseFavorites

  describe "verse_favorites" do
    alias Nota.VerseFavorites.VerseFavorite

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def verse_favorite_fixture(attrs \\ %{}) do
      {:ok, verse_favorite} =
        attrs
        |> Enum.into(@valid_attrs)
        |> VerseFavorites.create_verse_favorite()

      verse_favorite
    end

    test "list_verse_favorites/0 returns all verse_favorites" do
      verse_favorite = verse_favorite_fixture()
      assert VerseFavorites.list_verse_favorites() == [verse_favorite]
    end

    test "get_verse_favorite!/1 returns the verse_favorite with given id" do
      verse_favorite = verse_favorite_fixture()
      assert VerseFavorites.get_verse_favorite!(verse_favorite.id) == verse_favorite
    end

    test "create_verse_favorite/1 with valid data creates a verse_favorite" do
      assert {:ok, %VerseFavorite{} = verse_favorite} = VerseFavorites.create_verse_favorite(@valid_attrs)
    end

    test "create_verse_favorite/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = VerseFavorites.create_verse_favorite(@invalid_attrs)
    end

    test "update_verse_favorite/2 with valid data updates the verse_favorite" do
      verse_favorite = verse_favorite_fixture()
      assert {:ok, verse_favorite} = VerseFavorites.update_verse_favorite(verse_favorite, @update_attrs)
      assert %VerseFavorite{} = verse_favorite
    end

    test "update_verse_favorite/2 with invalid data returns error changeset" do
      verse_favorite = verse_favorite_fixture()
      assert {:error, %Ecto.Changeset{}} = VerseFavorites.update_verse_favorite(verse_favorite, @invalid_attrs)
      assert verse_favorite == VerseFavorites.get_verse_favorite!(verse_favorite.id)
    end

    test "delete_verse_favorite/1 deletes the verse_favorite" do
      verse_favorite = verse_favorite_fixture()
      assert {:ok, %VerseFavorite{}} = VerseFavorites.delete_verse_favorite(verse_favorite)
      assert_raise Ecto.NoResultsError, fn -> VerseFavorites.get_verse_favorite!(verse_favorite.id) end
    end

    test "change_verse_favorite/1 returns a verse_favorite changeset" do
      verse_favorite = verse_favorite_fixture()
      assert %Ecto.Changeset{} = VerseFavorites.change_verse_favorite(verse_favorite)
    end
  end
end
