defmodule Nota.Bible.Verse do
  use Ecto.Schema

  alias Nota.Annotations.Annotation
  
  schema "verses" do
    field :book_id, :integer
    field :chapter_id, :integer
    field :verse_id, :integer
    field :text, :string

    has_many :annotations, Annotation

  end
end