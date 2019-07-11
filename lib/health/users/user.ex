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
  def verify_password(user, password) do
    if Mix.env() == :dev do
      true
    else
      pow_verify_password(user, password)
    end
  end
end
