alias Nota.Repo
alias Nota.Annotations.Annotation
alias Nota.Auth.User

query = "copy verses(id, book_number, chapter_number, verse_number, text) from 'C:\\Code\\biblenotate\\bn-ex\\priv\\repo\\data\\t_web.csv' DELIMITER ',' CSV HEADER;"
Ecto.Adapters.SQL.query(Repo, query)

user = Repo.insert!(%User{
  email: "test@nota.com",
  first_name: "Luke",
  last_name: "Skywalker"
})

Repo.insert!(%Annotation{
  text: "First annotation",
  verse_id: 01001001,
  user_id: user.id
})

Repo.insert!(%Annotation{
  text: "Second annotation",
  verse_id: 01001001,
  user_id: user.id
})