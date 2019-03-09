defmodule Nota.AnnotationsTest do
  use Nota.DataCase

  alias Nota.Annotations

  describe "annotation" do
    alias Nota.Annotations.Annotation

    @valid_attrs %{text: "some text"}
    @update_attrs %{text: "some updated text"}
    @invalid_attrs %{text: nil}

    def annotation_fixture(attrs \\ %{}) do
      {:ok, annotation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Annotations.create_annotation()

      annotation
    end

    test "list_annotation/0 returns all annotation" do
      annotation = annotation_fixture()
      assert Annotations.list_annotation() == [annotation]
    end

    test "get_annotation!/1 returns the annotation with given id" do
      annotation = annotation_fixture()
      assert Annotations.get_annotation!(annotation.id) == annotation
    end

    test "create_annotation/1 with valid data creates a annotation" do
      assert {:ok, %Annotation{} = annotation} = Annotations.create_annotation(@valid_attrs)
      assert annotation.text == "some text"
    end

    test "create_annotation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Annotations.create_annotation(@invalid_attrs)
    end

    test "update_annotation/2 with valid data updates the annotation" do
      annotation = annotation_fixture()
      assert {:ok, annotation} = Annotations.update_annotation(annotation, @update_attrs)
      assert %Annotation{} = annotation
      assert annotation.text == "some updated text"
    end

    test "update_annotation/2 with invalid data returns error changeset" do
      annotation = annotation_fixture()
      assert {:error, %Ecto.Changeset{}} = Annotations.update_annotation(annotation, @invalid_attrs)
      assert annotation == Annotations.get_annotation!(annotation.id)
    end

    test "delete_annotation/1 deletes the annotation" do
      annotation = annotation_fixture()
      assert {:ok, %Annotation{}} = Annotations.delete_annotation(annotation)
      assert_raise Ecto.NoResultsError, fn -> Annotations.get_annotation!(annotation.id) end
    end

    test "change_annotation/1 returns a annotation changeset" do
      annotation = annotation_fixture()
      assert %Ecto.Changeset{} = Annotations.change_annotation(annotation)
    end
  end
end
