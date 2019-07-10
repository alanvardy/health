defmodule Health.Users.User do
  @moduledoc false
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    has_many :logs, Health.Stats.Log
    pow_user_fields()

    timestamps()
  end
end
