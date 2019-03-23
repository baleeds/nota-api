defmodule Nota.Auth.Guardian do
  @moduledoc false

  use Guardian, otp_app: :nota

  alias Nota.Auth
  alias Nota.Repo

  import Ecto.Query, only: [preload: 2]

  require Ecto

  # TODO: do I need to validate JTI in here?

  def subject_for_token(%{user_id: _} = resource, _), do: {:ok, resource}

  def subject_for_token(_resource, _claims), do: {:error, "invalid JWT resource"}

  def resource_from_claims(%{"sub" => %{"user_id" => user_id}}) do
    case Auth.get_user(user_id) do
      user ->
        {:ok, tenant_user}

      nil ->
        {:error, :unauthenticated}
    end
  end

  def resource_from_claims(_claims), do: {:error, "invalid JWT claims"}
end
