defmodule NotaWeb.Schema.Helpers do
  alias Absinthe.Adapter.LanguageConventions

  alias Absinthe.Resolution.Helpers

  @doc """
  Converts a regular ID to a global ID.  Parameter is the atom representing the schema node type.
  """
  @spec to_global_id(atom() | binary()) :: fun()
  def to_global_id(node_type) do
    fn parent, _args, %{definition: %{name: external_field_name}} ->
      field_name = LanguageConventions.to_internal_name(external_field_name, nil)

      case Map.get(parent, String.to_atom(field_name)) do
        nil -> {:ok, nil}
        value -> {:ok, Absinthe.Relay.Node.to_global_id(node_type, value, NotaWeb.Schema)}
      end
    end
  end

  def dataloader_with_context(source_name, args \\ %{}) when is_map(args) do
    Helpers.dataloader(
      source_name,
      fn _parent, _args, res ->
        resource = res.definition.schema_node.identifier

        {resource, map_args(args, res)}
      end
    )
  end

  defp map_args(args, %{context: context}) do
    Map.take(context, [:current_user, :current_user_id])
    |> Map.merge(args)
  end
end
