defmodule Pets.Pets.Owner do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pets.Pets.Pet

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "owners" do
    field :name, :string

    many_to_many(:pets, Pet, join_through: "pet_owners")

    timestamps()
  end

  @doc false
  def changeset(owner, attrs) do
    owner
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
