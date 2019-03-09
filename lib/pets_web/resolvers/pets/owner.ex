defmodule PetsWeb.Resolvers.Pets.Owner do
  alias Pets.{Pets}

  def all(_, _, _) do
    {:ok, Pets.list_owners()}
  end

  def create(_, %{input: create_subject_input}, _) do
    create_subject_input
    |> IO.inspect
    |> Pets.create_pet
    |> IO.inspect
    |> case do
      {:ok, pet} -> {:ok, %{
        created_subject_id: pet.id,
      }}
      
      {:error, changeset} ->
        {:error, transform_errors(changeset)}
    end
  end

  defp transform_errors(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(&format_error/1)
    |> Enum.map(fn
      {key, value} ->
        %{key: key, message: value}
    end)
  end

  @spec format_error(Ecto.Changeset.error()) :: String.t()
  defp format_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end