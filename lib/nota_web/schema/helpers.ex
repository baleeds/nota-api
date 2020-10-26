defmodule NotaWeb.Schema.Helpers do
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

  defp format_atom(_) do
    "An unexpected error has occured"
  end
end
