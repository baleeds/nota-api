defmodule Nota.Bible.Verse do
  use Ecto.Schema

  alias Nota.Annotations.Annotation
  
  schema "verses" do
    field :book_number, :integer
    field :chapter_number, :integer
    field :verse_number, :integer
    field :text, :string

    has_many :annotations, Annotation

  end
end