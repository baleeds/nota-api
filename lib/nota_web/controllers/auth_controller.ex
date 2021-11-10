defmodule NotaWeb.Controllers.AuthController do
  @moduledoc """
  Authentication controller responsible for handling Ueberauth responses
  """

  use NotaWeb, :controller

  alias Nota.Services.Auth

  # import Nota.Helpers, only: [utc_now: 0]
  # import NotaWeb.Resolvers.Helpers, only: [transform_errors: 1]

  # TODO: this is duplicate of the email helpers
  def frontend_url do
    "http://localhost:3000"
  end

  def callback(%{assigns: %{ueberauth_failure: failure}} = conn, _params) do
    conn |> redirect(external: "#{frontend_url()}/error?failure=#{Poison.encode!(failure)}")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    with {:ok, user} <- Auth.upsert_user(auth),
         {:ok, %{token: token}} <- Auth.get_user_authorization_token(user) do
      conn
      |> redirect(external: "#{frontend_url()}/login?authorization=#{token}&userId=#{user.id}")
    else
      {:error, errors} ->
        messages =
          case errors do
            errors when is_list(errors) ->
              Enum.map(errors, fn %{key: key, message: message} -> "#{key} #{message}" end)

            errors when is_binary(errors) ->
              [errors]

            _ ->
              ["something went wrong"]
          end

        conn |> redirect(external: "#{frontend_url()}/error?messages=#{Poison.encode!(messages)}")
    end
  end
end
