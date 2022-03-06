defmodule NotaWeb.Middleware.FormatErrorCodes do
  @behaviour Absinthe.Middleware

  def call(%{errors: [atom]} = resolution, _config) when is_atom(atom) do
    message = format_atom(atom)

    %{resolution | value: {:error, message}, errors: []}
  end

  def call(resolution, _config) do
    resolution
  end

  defp format_atom(:not_found) do
    "Not found"
  end

  defp format_atom(:invalid_credentials) do
    "Incorrect email or password"
  end

  defp format_atom(:invalid_password) do
    "Password is incorrect or invalid"
  end

  defp format_atom(:unauthenticated) do
    "You must be authenticated to perform this action"
  end

  defp format_atom(_) do
    "An unexpected error has occured"
  end
end
