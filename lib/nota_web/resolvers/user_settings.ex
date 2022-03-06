defmodule NotaWeb.Resolvers.UserSettings do
  alias Nota.Services.UserSettings

  def change_display_name(_, %{input: %{first_name: first_name, last_name: last_name}}, %{
        context: %{current_user: %{id: user_id}}
      }) do
    UserSettings.change_display_name(user_id, first_name, last_name)
  end

  def change_display_name(_, _, _) do
    {:error, :unknown}
  end

  def change_password(_, %{input: %{old_password: old_password, new_password: new_password}}, %{
        context: %{current_user: %{id: user_id}}
      }) do
    UserSettings.change_password(user_id, old_password, new_password)
  end

  def change_password(_, _, _) do
    {:error, :unknown}
  end
end
