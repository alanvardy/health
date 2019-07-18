defmodule Health.Account.User do
  @moduledoc false
  alias Health.UserPolicy
  use Ecto.Schema
  use Pow.Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    has_many :logs, Health.Weight.Log
    field :roles, :integer
    pow_user_fields()

    timestamps()
  end

  defdelegate authorize(action, user, params), to: UserPolicy

  @spec changeset(
          {map, map} | %{:__struct__ => atom | %{__changeset__: map}, optional(atom) => any},
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:roles])
    |> validate_required([:roles])
    |> validate_number(:roles, greater_than: 0, less_than: 11)
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
