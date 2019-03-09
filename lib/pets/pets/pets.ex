defmodule Pets.Pets do
  @moduledoc """
  The Pets context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Pets.Repo

  alias Pets.Pets.Pet

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end

  def list_pets do
    Repo.all(Pet)
  end

  def get_pet!(id), do: Repo.get!(Pet, id)

  def create_pet(attrs \\ %{}) do
    %Pet{}
    |> Pet.changeset(attrs)
    |> Repo.insert()
  end

  def update_pet(%Pet{} = pet, attrs) do
    pet
    |> Pet.changeset(attrs)
    |> Repo.update()
  end

  def delete_pet(%Pet{} = pet) do
    Repo.delete(pet)
  end

  def change_pet(%Pet{} = pet) do
    Pet.changeset(pet, %{})
  end


  alias Pets.Pets.Owner

  def list_owners do
    Repo.all(Owner)
  end

  def get_owner!(id), do: Repo.get!(Owner, id)

  def create_owner(attrs \\ %{}) do
    %Owner{}
    |> Owner.changeset(attrs)
    |> Repo.insert()
  end

  def update_owner(%Owner{} = owner, attrs) do
    owner
    |> Owner.changeset(attrs)
    |> Repo.update()
  end

  def delete_owner(%Owner{} = owner) do
    Repo.delete(owner)
  end

  def change_owner(%Owner{} = owner) do
    Owner.changeset(owner, %{})
  end


  alias Pets.Pets.PetOwner

  def get_pet_owner!(id), do: Repo.get!(PetOwner, id)

  def create_pet_owner(attrs \\ %{}) do
    %PetOwner{}
    |> PetOwner.changeset(attrs)
    |> Repo.insert()
  end


  # def update_pet(%{owner_ids: owner_ids} = attrs) do
  #   Multi.new()
  #   |> Multi.append(get_pet_multi(attrs))
  #   |> Multi.run(:owner_ids, fn _ -> {:ok, owner_ids} end)
  #   |> Multi.run(:deleted_pet_owners, &tx_delete_old_pet_owners/1)
  # end

  # defp tx_delete_old_pet_owners(%{pet: %Pet{}, owner_ids: owner_ids}) do
  #   old_pet_ids
  # end

  defp get_pet_multi(%{pet_id: pet_id}) do
    Multi.new()
    |> Multi.run(:pet_id, fn _ -> {:ok, pet_id} end)
    |> Multi.run(:pet, &tx_get_pet/1)
  end

  defp get_owner_multi(%{owner_id: owner_id}) do
    Multi.new()
    |> Multi.run(:owner_id, fn _ -> {:ok, owner_id} end)
    |> Multi.run(:owner, &tx_get_owner/1)
  end

  # with {:ok, user} <- Repo.fetch(user_query),
    #   {:ok, account} <- Repo.fetch(authorized_account_query),
    #   {:ok, membership} <- Repo.insert(membership_changeset(user, account)) do
    #     send_welcome_email(membership)
    #     {:ok, membership}
    # end

  def add_owner_to_pet(%{pet_id: pet_id, owner_id: owner_id} = attrs) do
    Multi.new()
    |> Multi.append(get_pet_multi(attrs))
    |> Multi.append(get_owner_multi(attrs))
    |> Multi.run(:updated_pet, &tx_update_pet_owners/1)
    |> Repo.transaction()
    |> case do
      {:ok, %{updated_pet: updated_pet}} -> {:ok, updated_pet}
      error -> error
    end
  end

  defp tx_get_pet(%{pet_id: pet_id}) do
    get_pet!(pet_id)
    |> case do
      nil -> {:error, "pet not found"}
      pet -> {:ok, pet |> Repo.preload(:owners)}
    end
  end

  defp tx_get_owner(%{owner_id: owner_id}) do
    get_owner!(owner_id)
    |> case do
      nil -> {:error, "owner not found"}
      owner -> {:ok, owner}
    end
  end

  defp tx_update_pet_owners(%{pet: pet, owner: owner}) do
    pet
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:owners, [owner | pet.owners])
    |> Repo.update()
  end
end
