alias Nota.Repo
alias Nota.Annotations.Annotation

query = "copy verses(id, book_number, chapter_number, verse_number, text) from 'C:\\Code\\biblenotate\\bn-ex\\priv\\repo\\data\\t_web.csv' DELIMITER ',' CSV HEADER;"
Ecto.Adapters.SQL.query(Repo, query)

Repo.insert!(%Annotation{
  text: "First annotation",
  verse_id: 01001001
})

Repo.insert!(%Annotation{
  text: "Second annotation",
  verse_id: 01001001
})