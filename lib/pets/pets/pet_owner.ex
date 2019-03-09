defmodule Pets.Pets.PetOwner do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pets.Pets.{Owner, Pet}

  @required_fields ~w(
    owner_id
    pet_id
  )a

  @optional_fields ~w()a

  @all_fields @required_fields ++ @optional_fields

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "pet_owners" do
    # many_to_many(:owners, Owner, join_through: "pet_owners")
    belongs_to(:owner, Owner, type: :binary_id)
    belongs_to(:pet, Pet, type: :binary_id)

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:owner_id)
    |> foreign_key_constraint(:pet_id)
  end
end
