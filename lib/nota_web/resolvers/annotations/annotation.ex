defmodule NotaWeb.Resolvers.Annotations.Annotation do
  alias Nota.Annotations

  def get(_, %{id: id}, _) do
    Annotations.get_annotation!(id)
    |> case do
      nil -> {:error, "Error retrieving annotation"}
      annotation -> {:ok, annotation}
    end
  end

  def get_all(_, _, context) do
    inspect_user(context)
    Annotations.list_annotation()
    |> case do
      nil -> {:error, "Error retrieving annotations"}
      annotations -> {:ok, annotations}
    end
  end

  def inspect_user(%{context: %{ current_user: user } }) do
    IO.inspect(user, label: "contextual user")
  end

  def inspect_user(_) do
    IO.inspect("NO USER")
  end

  def save(_, %{input: input}, _) do
    Annotations.save_annotation(input)
    |> IO.inspect
    |> case do
      {:ok, annotation} -> {:ok, %{annotation: annotation}}
      e -> e
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