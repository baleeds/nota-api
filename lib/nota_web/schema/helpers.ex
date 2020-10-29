defmodule NotaWeb.Schema.Helpers do
  alias Absinthe.Adapter.LanguageConventions

  @doc """
  Converts a regular ID to a global ID.  Parameter is the atom representing the schema node type.
  """
  @spec to_global_id(atom() | binary()) :: fun()
  def to_global_id(node_type) do
    fn parent, args, %{definition: %{name: external_field_name}} ->
      IO.inspect(args)

      field_name = LanguageConventions.to_internal_name(external_field_name, nil)
      IO.inspect(field_name, label: "Field name")

      case Map.get(parent, String.to_atom(field_name)) do
        nil -> {:ok, nil}
        value -> {:ok, Absinthe.Relay.Node.to_global_id(node_type, value, NotaWeb.Schema)}
      end
    end
  end

  def format_error_tuples(%{errors: [atom]} = resolution, _config) when is_atom(atom) do
    message = format_atom(atom)

    %{resolution | value: {:error, message}, errors: []}
  end

  def format_error_tuples(resolution, _config) do
    resolution
  end

  defp format_atom(:not_found) do
    "Not found"
  end

  defp format_atom(:invalid_credentials) do
    "Incorrect email or password"
  end

  defp format_atom(:unauthenticated) do
    "You must be authenticated to perform this action"
  end

  defp format_atom(_) do
    "An unexpected error has occured"
  end
end
