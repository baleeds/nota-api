defmodule PetsWeb.Resolvers.Pets.Pet do
  alias Pets.{Pets}
  alias Pets.Pet

  def all(_, _, _) do
    {:ok, Pets.list_pets()}
  end

  def create(_, %{input: create_pet_input}, _) do
    create_pet_input
    |> IO.inspect
    |> Pets.create_pet
    |> IO.inspect
    |> case do
      {:ok, pet} -> {:ok, %{
        created_pet_id: pet.id,
      }}
      
      {:error, changeset} ->
        {:error, transform_errors(changeset)}
    end
  end

  def add_owner_to_pet(_, %{input: add_owner_to_pet_input}, _) do
    add_owner_to_pet_input
    |> Pets.add_owner_to_pet
    |> case do
      {:ok, pet} -> {:ok, %{
        pet: pet
      }}
      
      {:error, changeset} -> {:error, transform_errors(changeset)}
    end
  end

  def update_pet(_, %{input: update_pet_input}, _) do
    with %Pet{} = pet <- Pets.get_pet!(update_pet_input.id) do
      pet
      |> IO.inspect
      |> Pets.update_pet(update_pet_input)
      |> IO.inspect
      |> case do
        {:ok, pet} -> {:ok, %{
          pet: pet
        }}

        {:error, changeset} -> {:error, transform_errors(changeset)}
      end
    else
      nil -> {:error, "no pet found"}
      {:error, error} -> {:error, error}
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