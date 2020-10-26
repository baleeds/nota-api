defmodule Ecto.Email do
  alias Ecto.Type

  def type, do: :string

  def cast(nil), do: {:ok, nil}

  def cast(binary) when is_binary(binary) do
    binary = binary |> String.trim() |> String.downcase()

    if is_valid_email?(binary) do
      {:ok, binary}
    else
      :error
    end
  end

  def cast(_other), do: :error

  def load(value), do: Type.load(:string, value)

  def dump(value), do: Type.dump(:string, value)

  def equal?(nil, _email1) do
    false
  end

  def equal?(_email1, nil) do
    false
  end

  def equal?(nil, nil) do
    true
  end

  def equal?(email1, email2) do
    String.equivalent?(email1, email2)
  end

  @email_regex ~r/^(?<user>[^\s]+)@(?<domain>[^\s]+\.[^\s]+)$/

  def is_valid_email?(email) when is_binary(email) do
    email =~ @email_regex
  end

  def is_valid_email?(_), do: false
end
