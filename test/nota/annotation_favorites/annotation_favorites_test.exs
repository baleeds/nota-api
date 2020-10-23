defmodule Nota.AnnotationFavoritesTest do
  use Nota.DataCase

  alias Nota.AnnotationFavorites

  describe "annotation_favorites" do
    alias Nota.AnnotationFavorites.AnnotationFavorite

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def annotation_favorite_fixture(attrs \\ %{}) do
      {:ok, annotation_favorite} =
        attrs
        |> Enum.into(@valid_attrs)
        |> AnnotationFavorites.create_annotation_favorite()

      annotation_favorite
    end

    test "list_annotation_favorites/0 returns all annotation_favorites" do
      annotation_favorite = annotation_favorite_fixture()
      assert AnnotationFavorites.list_annotation_favorites() == [annotation_favorite]
    end

    test "get_annotation_favorite!/1 returns the annotation_favorite with given id" do
      annotation_favorite = annotation_favorite_fixture()
      assert AnnotationFavorites.get_annotation_favorite!(annotation_favorite.id) == annotation_favorite
    end

    test "create_annotation_favorite/1 with valid data creates a annotation_favorite" do
      assert {:ok, %AnnotationFavorite{} = annotation_favorite} = AnnotationFavorites.create_annotation_favorite(@valid_attrs)
    end

    test "create_annotation_favorite/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = AnnotationFavorites.create_annotation_favorite(@invalid_attrs)
    end

    test "update_annotation_favorite/2 with valid data updates the annotation_favorite" do
      annotation_favorite = annotation_favorite_fixture()
      assert {:ok, annotation_favorite} = AnnotationFavorites.update_annotation_favorite(annotation_favorite, @update_attrs)
      assert %AnnotationFavorite{} = annotation_favorite
    end

    test "update_annotation_favorite/2 with invalid data returns error changeset" do
      annotation_favorite = annotation_favorite_fixture()
      assert {:error, %Ecto.Changeset{}} = AnnotationFavorites.update_annotation_favorite(annotation_favorite, @invalid_attrs)
      assert annotation_favorite == AnnotationFavorites.get_annotation_favorite!(annotation_favorite.id)
    end

    test "delete_annotation_favorite/1 deletes the annotation_favorite" do
      annotation_favorite = annotation_favorite_fixture()
      assert {:ok, %AnnotationFavorite{}} = AnnotationFavorites.delete_annotation_favorite(annotation_favorite)
      assert_raise Ecto.NoResultsError, fn -> AnnotationFavorites.get_annotation_favorite!(annotation_favorite.id) end
    end

    test "change_annotation_favorite/1 returns a annotation_favorite changeset" do
      annotation_favorite = annotation_favorite_fixture()
      assert %Ecto.Changeset{} = AnnotationFavorites.change_annotation_favorite(annotation_favorite)
    end
  end
end
