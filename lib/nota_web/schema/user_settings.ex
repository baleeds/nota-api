defmodule NotaWeb.Schema.UserSettings do
  import AbsintheErrorPayload.Payload

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias NotaWeb.Resolvers.UserSettings

  input_object(:change_display_name_input) do
    field(:first_name, non_null(:string))
    field(:last_name, non_null(:string))
  end

  input_object(:change_password_input) do
    field(:old_password, non_null(:string))
    field(:new_password, non_null(:string))
  end

  payload_object(:change_display_name_payload, :user)

  payload_object(:change_password_payload, :boolean)

  object :user_settings_mutations do
    field :change_display_name, non_null(:change_display_name_payload) do
      arg(:input, non_null(:change_display_name_input))

      resolve(&UserSettings.change_display_name/3)
    end

    field :change_password, non_null(:change_password_payload) do
      arg(:input, non_null(:change_password_input))

      resolve(&UserSettings.change_password/3)
    end
  end
end
