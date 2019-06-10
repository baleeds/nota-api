defmodule NotaWeb.Resolvers.Bible.Verse do
  alias Nota.Bible

  def get(_, %{id: id}, context) do
    IO.inspect(context)
    Bible.get_verse(id)
    |> case do
      nil -> {:error, "Error retrieving verse"}
      verse -> {:ok, verse}
    end
  end

  def get_by(_, params, _) do
    Bible.get_verses(params)
    |> case do
      nil -> {:error, "Error retrieving verses"}
      verses -> {:ok, verses}
    end
  end

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