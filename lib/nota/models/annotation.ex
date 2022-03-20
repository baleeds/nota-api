defmodule Nota.Models.Annotation do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Nota.Models.{Verse, User, AnnotationFavorite}

  @required_fields ~w(
    verse_id
    user_id
    text
  )a

  @optional_fields ~w(
    id
    last_synced_at
    inserted_at
    updated_at
    deleted_at
  )a

  @all_fields @required_fields ++ @optional_fields

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "annotations" do
    field(:text, :string)
    field(:last_synced_at, :utc_datetime)
    field(:deleted_at, :utc_datetime)

    field(:is_favorite, :boolean, virtual: true)
    field(:is_mine, :boolean, virtual: true)

    belongs_to(:verse, Verse, type: :integer)
    belongs_to(:user, User)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(annotation, attrs) do
    annotation
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:verse_id)
    |> foreign_key_constraint(:user_id)
  end

  def include_is_favorite(query, nil) do
    from(a in query,
      left_join: f in AnnotationFavorite,
      on: true == false,
      select_merge: %{is_favorite: fragment("? IS NOT NULL", f.id)}
    )
  end

  def include_is_favorite(query, user_id) do
    from(a in query,
      left_join: f in AnnotationFavorite,
      on: f.user_id == ^user_id and f.annotation_id == a.id,
      select_merge: %{is_favorite: fragment("? IS NOT NULL", f.id)}
    )
  end

  def include_is_mine(query, nil) do
    from(a in query,
      select_merge: %{is_mine: false}
    )
  end

  def include_is_mine(query, user_id) do
    from(a in query,
      select_merge: %{is_mine: a.user_id == ^user_id}
    )
  end

  def order_by_is_mine(query, nil) do
    query
  end

  def order_by_is_mine(query, user_id) do
    query
    |> order_by([a], desc: a.user_id == ^user_id)
  end

  def where_is_favorite(query, %{is_favorite: is_favorite}) do
    query
    |> where([a, f], fragment("? IS NOT NULL", f.id) == ^is_favorite)
  end

  def where_is_favorite(query, _) do
    query
  end

  def where_is_mine(query, %{current_user_id: current_user_id, is_mine: is_mine})
      when not is_nil(current_user_id) do
    query
    |> where([a], a.user_id == ^current_user_id == ^is_mine)
  end

  def where_is_mine(query, _) do
    query
  end
end
