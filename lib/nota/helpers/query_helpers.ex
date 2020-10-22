defmodule Nota.Helpers.QueryHelpers do
  import Ecto.Query, warn: false

  def where_from_args(queryable, args, valid_keys) do
    where_list =
      args
      |> Enum.to_list()
      |> Keyword.take(valid_keys)

    queryable
    |> where(^where_list)
  end
end
