defmodule Health.Users.User do
  @moduledoc false
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    has_many :logs, Health.Stats.Log
    pow_user_fields()

    timestamps()
  end

  # Any pow password works in development mode
  # coveralls-ignore-start
  @spec verify_password(String.t(), String.t()) :: boolean()
  def verify_password(user, password) do
    case Mix.env() do
      :dev -> true
      _ -> pow_verify_password(user, password)
    end
  end
  # coveralls-ignore-stop
end
