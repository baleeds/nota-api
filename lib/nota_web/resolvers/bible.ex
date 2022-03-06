defmodule NotaWeb.Resolvers.Bible do
  alias Nota.Services.Bible

  def get_verse(_, %{id: id}, %{context: context}) do
    Bible.get_verse(id, context)
    |> case do
      nil -> {:error, "Error retrieving verse"}
      verse -> {:ok, verse}
    end
  end

  def get_verses_by(_, params, %{context: context}) do
    Bible.get_verses(params, context)
    |> case do
      nil -> {:error, "Error retrieving verses"}
      verses -> {:ok, verses}
    end
  end

  def bookmark_verse(_, %{input: %{verse_id: verse_id}}, %{
        context: %{current_user: %{id: user_id}} = context
      }) do
    Bible.bookmark_verse(user_id, verse_id)
    |> case do
      {:ok, _} -> {:ok, Bible.get_verse(verse_id, context)}
      {:error, error} -> {:error, error}
    end
  end

  def bookmark_verse(_, _, _), do: {:error, :unknown}

  def unbookmark_verse(_, %{input: %{verse_id: verse_id}}, %{
        context: %{current_user: %{id: user_id}} = context
      }) do
    Bible.unbookmark_verse(user_id, verse_id)
    |> case do
      {:ok, _} -> {:ok, Bible.get_verse(verse_id, context)}
      {:error, error} -> {:error, error}
    end
  end

  def unbookmark_verse(_, _, _), do: {:error, :unknown}

  def is_verse_bookmarked(%{id: verse_id}, _, %{context: %{current_user: %{id: user_id}}}) do
    Bible.is_verse_bookmarked(user_id, verse_id)
  end

  def is_verse_bookmarked(_, _, _), do: {:ok, false}

  # defp transform_errors(changeset) do
  #   changeset
  #   |> Ecto.Changeset.traverse_errors(&format_error/1)
  #   |> Enum.map(fn
  #     {key, value} ->
  #       %{key: key, message: value}
  #   end)
  # end

  # @spec format_error(Ecto.Changeset.error()) :: String.t()
  # defp format_error({msg, opts}) do
  #   Enum.reduce(opts, msg, fn {key, value}, acc ->
  #     String.replace(acc, "%{#{key}}", to_string(value))
  #   end)
  # end
end
