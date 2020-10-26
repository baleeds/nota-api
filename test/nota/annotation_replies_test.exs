defmodule Nota.AnnotationRepliesTest do
  use Nota.DataCase

  alias Nota.AnnotationReplies

  describe "annotation_replies" do
    alias Nota.AnnotationReplies.AnnotationReply

    @valid_attrs %{text: "some text"}
    @update_attrs %{text: "some updated text"}
    @invalid_attrs %{text: nil}

    def annotation_reply_fixture(attrs \\ %{}) do
      {:ok, annotation_reply} =
        attrs
        |> Enum.into(@valid_attrs)
        |> AnnotationReplies.create_annotation_reply()

      annotation_reply
    end

    test "list_annotation_replies/0 returns all annotation_replies" do
      annotation_reply = annotation_reply_fixture()
      assert AnnotationReplies.list_annotation_replies() == [annotation_reply]
    end

    test "get_annotation_reply!/1 returns the annotation_reply with given id" do
      annotation_reply = annotation_reply_fixture()
      assert AnnotationReplies.get_annotation_reply!(annotation_reply.id) == annotation_reply
    end

    test "create_annotation_reply/1 with valid data creates a annotation_reply" do
      assert {:ok, %AnnotationReply{} = annotation_reply} = AnnotationReplies.create_annotation_reply(@valid_attrs)
      assert annotation_reply.text == "some text"
    end

    test "create_annotation_reply/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = AnnotationReplies.create_annotation_reply(@invalid_attrs)
    end

    test "update_annotation_reply/2 with valid data updates the annotation_reply" do
      annotation_reply = annotation_reply_fixture()
      assert {:ok, %AnnotationReply{} = annotation_reply} = AnnotationReplies.update_annotation_reply(annotation_reply, @update_attrs)
      assert annotation_reply.text == "some updated text"
    end

    test "update_annotation_reply/2 with invalid data returns error changeset" do
      annotation_reply = annotation_reply_fixture()
      assert {:error, %Ecto.Changeset{}} = AnnotationReplies.update_annotation_reply(annotation_reply, @invalid_attrs)
      assert annotation_reply == AnnotationReplies.get_annotation_reply!(annotation_reply.id)
    end

    test "delete_annotation_reply/1 deletes the annotation_reply" do
      annotation_reply = annotation_reply_fixture()
      assert {:ok, %AnnotationReply{}} = AnnotationReplies.delete_annotation_reply(annotation_reply)
      assert_raise Ecto.NoResultsError, fn -> AnnotationReplies.get_annotation_reply!(annotation_reply.id) end
    end

    test "change_annotation_reply/1 returns a annotation_reply changeset" do
      annotation_reply = annotation_reply_fixture()
      assert %Ecto.Changeset{} = AnnotationReplies.change_annotation_reply(annotation_reply)
    end
  end
end
