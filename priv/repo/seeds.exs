alias Pets.Repo
alias Pets.Pets.{
  Pet,
  Owner,
}

Repo.insert!(%Owner{
  name: "Ben",
})

Repo.insert!(%Owner{
  name: "Erica",
})

Repo.insert!(%Owner{
  name: "Marie",
})

Repo.insert!(%Pet{
  name: "Snow",
  breed: "Cat"
})

Repo.insert!(%Pet{
  name: "Rocky",
  breed: "Dog",
})