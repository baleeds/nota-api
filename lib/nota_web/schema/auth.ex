defmodule NotaWeb.Schema.Auth do
  import AbsintheErrorPayload.Payload

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias NotaWeb.Resolvers.Auth

  import NotaWeb.Schema.Helpers, only: [to_global_id: 1]

  connection(node_type: :user)

  node object(:user) do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:email, non_null(:string))
    field(:is_admin, non_null(:boolean))

    # field(:annotations, list_of(non_null(:annotation)), resolve: dataloader(Annotations.Annotation))
  end

  object :session_info do
    field(:access_token, non_null(:string))
    field(:refresh_token, :string)
    field(:user_id, :id, resolve: to_global_id(:user))

    field(:user, non_null(:user)) do
      resolve(&Auth.get_user_for_session/3)
    end
  end

  object :auth_queries do
    field :user, non_null(:user) do
      arg(:id, non_null(:id))

      middleware(Absinthe.Relay.Node.ParseIDs, id: :user)

      resolve(&Auth.get_user/3)
    end

    # connection field(:users, node_type: :user) do
    #   resolve(&User.get_users/3)
    # end

    field :me, :user do
      resolve(&Auth.get_me/3)
    end
  end

  input_object(:create_account_input) do
    field(:email, non_null(:string))
    field(:password, non_null(:string))
    field(:first_name, non_null(:string))
    field(:last_name, :string)
  end

  input_object(:sign_in_input) do
    field(:email, non_null(:string))
    field(:password, non_null(:string))
  end

  input_object(:send_forgot_password_input) do
    field(:email, non_null(:string))
  end

  input_object(:reset_password_input) do
    field(:token, non_null(:string))
    field(:password, non_null(:string))
  end

  payload_object(:create_account_payload, :user)

  payload_object(:sign_in_payload, :session_info)

  payload_object(:refresh_token_payload, :session_info)

  payload_object(:send_forgot_password_payload, :boolean)

  payload_object(:reset_password_payload, :boolean)

  payload_object(:sign_out_payload, :boolean)

  object :auth_mutations do
    field :create_account, non_null(:create_account_payload) do
      arg(:input, non_null(:create_account_input))

      resolve(&Auth.create_account/3)
    end

    field(:sign_in, non_null(:sign_in_payload)) do
      arg(:input, non_null(:sign_in_input))

      resolve(&Auth.sign_in/3)
    end

    field :refresh_token, non_null(:refresh_token_payload) do
      arg(:refresh_token, non_null(:string))

      resolve(&Auth.refresh_token/3)
    end

    field :send_forgot_password, non_null(:send_forgot_password_payload) do
      arg(:input, non_null(:send_forgot_password_input))

      resolve(&Auth.send_forgot_password/3)
    end

    field :reset_password, non_null(:reset_password_payload) do
      arg(:input, non_null(:reset_password_input))

      resolve(&Auth.reset_password/3)
    end

    field :sign_out_everywhere, non_null(:sign_out_payload) do
      resolve(&Auth.sign_out_everywhere/3)
    end

    field :sign_out, non_null(:sign_out_payload) do
      arg(:refresh_token, non_null(:string))

      resolve(&Auth.sign_out/3)
    end
  end
end
