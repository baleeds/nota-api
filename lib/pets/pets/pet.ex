defmodule Pets.Pets.Pet do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pets.Pets.Owner

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "pets" do
    field :breed, :string
    field :name, :string

    many_to_many(:owners, Owner, join_through: "pet_owners")

    timestamps()
  end

  @doc false
  def changeset(pet, attrs) do
    pet
    |> cast(attrs, [:name, :breed])
    |> validate_required([:name, :breed])
  end
end
