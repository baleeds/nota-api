defmodule Nota.Helpers.Multi do
  alias Ecto.Multi

  def add(transaction, name, value) when is_atom(name) do
    transaction
    |> Multi.run(name, fn _, _ -> {:ok, value} end)
  end
end
