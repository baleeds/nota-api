alias Nota.Repo
# alias Nota.Nota.{
#   Pet,
#   Owner,
# }

# Repo.insert!(%Owner{
#   name: "Ben",
# })

# Repo.insert!(%Owner{
#   name: "Erica",
# })

# Repo.insert!(%Owner{
#   name: "Marie",
# })

# Repo.insert!(%Pet{
#   name: "Snow",
#   breed: "Cat"
# })

# Repo.insert!(%Pet{
#   name: "Rocky",
#   breed: "Dog",
# })

query = "copy verses(id, book, chapter, verse, text) from 'C:\\Code\\biblenotate\\bn-ex\\priv\\repo\\data\\t_web.csv' DELIMITER ',' CSV HEADER;"
Ecto.Adapters.SQL.query(Repo, query)